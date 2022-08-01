describe Middleware::ContentSecurityPolicy do
  subject(:middleware) { described_class.new(app, csp_options) }

  let(:app) do
    app = double
    allow(app).to receive(:call).and_return([200, Rack::Utils::HeaderHash.new({ "Content-Type" => "text/html" }), "some content"])
    app
  end

  let(:csp_options) do
    {
      style_src: "'unsafe-inline' 'self'",
      img_src: "'self' data:",
      report_uri: "https://test-csp-endpoint.com/",
    }
  end

  context "when no flags are enabled and no reporting ratio set" do
    it "calls down onto the underlying app object with CSP headers set in report only mode" do
      _, headers, = middleware.call(nil)
      expect(headers.key?("Content-Security-Policy-Report-Only")).to be true
    end

    it "calls down onto the underlying app object with report_uri still set" do
      _, headers, = middleware.call(nil)
      expect(headers["Content-Security-Policy-Report-Only"]).to include "report-uri https:"
    end
  end

  context "when enforce CSP flag is on and report_only option not set, or false" do
    before { Helper::Toggles.set_feature("frontend-enforce-content-security-policy", true) }

    it "calls down onto the underlying app object with CSP headers set in enforce mode" do
      _, headers, = middleware.call(nil)
      expect(headers.key?("Content-Security-Policy")).to be true
    end
  end

  context "when enforce CSP flag is on and report_only option set to true" do
    report_only_middleware = nil

    before do
      Helper::Toggles.set_feature("frontend-enforce-content-security-policy", true)
      report_only_middleware = described_class.new(app, csp_options.merge(report_only: true))
    end

    after do
      Helper::Toggles.set_feature("frontend-enforce-content-security-policy", false)
    end

    it "calls down onto the underlying app object with CSP headers set in report only mode" do
      _, headers = report_only_middleware.call(nil)
      expect(headers.key?("Content-Security-Policy-Report-Only")).to be true
    end
  end

  context "when enforce CSP flag is not on and report_only option set to true", aggregate_failures: true do
    report_only_middleware = nil

    before do
      report_only_middleware = described_class.new(app, csp_options.merge(report_only: true))
    end

    it "calls down onto the underlying app object with CSP headers set in report only mode and exposes these headers correctly" do
      _, headers = report_only_middleware.call(nil)
      expect(headers.key?("Content-Security-Policy-Report-Only")).to be true
      expect(headers["Content-Security-Policy-Report-Only"]).not_to be nil
    end
  end

  context "when a report ratio is set" do
    let(:middleware_with_ratio) do
      lambda do |ratio|
        described_class.new(app, csp_options.merge(report_ratio: ratio))
      end
    end

    context "with a value of 0 (never)" do
      let(:ratio) { 0 }

      it "would send a report 0 times over 100 requests" do
        ratioed_middleware = middleware_with_ratio.call(ratio)
        expect(
          1.upto(100).reduce(0) do |count|
            count += 1 if ratioed_middleware.call(nil)[1]["Content-Security-Policy-Report-Only"]&.include?("report-uri https:")
            count
          end,
        ).to eq 0
      end
    end

    context "with a value of 1 (always)" do
      let(:ratio) { 1 }

      it "would send a report 100 times over 100 requests" do
        ratioed_middleware = middleware_with_ratio.call(ratio)
        expect(
          1.upto(100).reduce(0) do |count|
            headers = ratioed_middleware.call(nil)[1]
            count += 1 if headers["Content-Security-Policy-Report-Only"]&.include?("report-uri https:")
            count
          end,
        ).to eq 100
      end
    end

    context "with a value of 1/4 (1:3)" do
      let(:ratio) { 1/4r }

      it "would send a report between 1 and 75 times over 100 requests" do
        ratioed_middleware = middleware_with_ratio.call(ratio)
        expect(
          1.upto(100).reduce(0) do |count|
            count += 1 if ratioed_middleware.call(nil)[1]["Content-Security-Policy-Report-Only"]&.include?("report-uri https:")
            count
          end,
        ).to be_between 1, 75
      end
    end
  end
end
