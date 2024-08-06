describe Middleware::ContentSecurityPolicy do
  subject(:middleware) { described_class.new(app, csp_options) }

  let(:app) do
    app = double
    allow(app).to receive(:call).and_return([200, Rack::Headers.new.merge({ "Content-Type" => "text/html" }), "some content"])
    app
  end

  let(:csp_options) do
    {
      style_src: "'unsafe-inline' 'self'",
      img_src: "'self' data:",
      report_uri: "https://test-csp-endpoint.com/",
    }
  end

  context "when no reporting ratio set" do
    it "calls down onto the underlying app object with CSP headers" do
      _, headers, = middleware.call(nil)
      expect(headers.key?("content-security-policy")).to be true
    end

    it "calls down onto the underlying app object with report_uri still set" do
      _, headers, = middleware.call(nil)
      expect(headers["content-security-policy"]).to include "report-uri https:"
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
            count += 1 if ratioed_middleware.call(nil)[1]["content-security-policy"]&.include?("report-uri https:")
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
            count += 1 if headers["content-security-policy"]&.include?("report-uri https:")
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
            count += 1 if ratioed_middleware.call(nil)[1]["content-security-policy"]&.include?("report-uri https:")
            count
          end,
        ).to be_between 1, 75
      end
    end
  end
end
