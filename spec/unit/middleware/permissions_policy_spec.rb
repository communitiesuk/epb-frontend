describe Middleware::PermissionsPolicy do
  subject(:middleware) { described_class.new(app) }

  let(:policy) do
    "accelerometer=(), autoplay=(), camera=(), cross-origin-isolated=(), display-capture=*, encrypted-media=*, fullscreen=*, geolocation=(), gyroscope=(), keyboard-map=(), magnetometer=(), microphone=(), midi=(), payment=(), picture-in-picture=(), publickey-credentials-get=(), screen-wake-lock=(), sync-xhr=(), usb=(), xr-spatial-tracking=()"
  end

  context "when the middleware is used on an HTML response" do
    let(:app) do
      app = double
      allow(app).to receive(:call).and_return([200,
                                               Rack::Headers.new.merge({ "Content-Type" => "text/html", "x-frame-options" => "SAMEORIGIN", "x-xss-protection" => "1; mode=bloc" }),
                                               "some content"])
      app
    end

    it "adds the expected Permissions-Policy header to any response" do
      _, headers, = middleware.call(nil)
      expect(headers["Permissions-Policy"]).to eq policy
    end

    it "includes the Referrer-Policy header" do
      _, headers, = middleware.call(nil)
      expect(headers["Referrer-Policy"]).to eq "strict-origin-when-cross-origin"
    end

    it "includes the Strict-Transport-Security header" do
      _, headers, = middleware.call(nil)
      expect(headers["Strict-Transport-Security"]).to eq "max-age=300; includeSubDomains; preload"
    end

    it "the header do not include the deprecated keys 'x-frame-options' and 'x-xss-protection'" do
      _, headers, = middleware.call(nil)
      header_keys = %w[content-type permissions-policy referrer-policy strict-transport-security]
      expect(headers.keys).to eq header_keys
    end
  end

  context "when the middleware is used on a text javascript response" do
    let(:app) do
      app = double
      allow(app).to receive(:call).and_return([200,
                                               Rack::Headers.new.merge({ "Content-Type" => "text/javascript" }),
                                               "some content"])
      app
    end

    it "adds the expected Permissions-Policy header to any response" do
      _, headers, = middleware.call(nil)
      expect(headers["Permissions-Policy"]).to eq policy
    end
  end

  context "when the middleware is used on an application javascript response" do
    let(:app) do
      app = double
      allow(app).to receive(:call).and_return([200,
                                               Rack::Headers.new.merge({ "Content-Type" => "application/javascript" }),
                                               "some content"])
      app
    end

    it "adds the expected Permissions-Policy header to any response" do
      _, headers, = middleware.call(nil)
      expect(headers["Permissions-Policy"]).to eq policy
    end
  end

  context "when the middleware is used on a non-HTML response like CSS" do
    let(:app) do
      app = double
      allow(app).to receive(:call).and_return([200,
                                               Rack::Headers.new.merge({ "Content-Type" => "text/css" }),
                                               "body { background-color: goldenrod; }"])
      app
    end

    it "does not add a Permissions-Policy header" do
      _, headers, = middleware.call(nil)
      expect(headers.key?("Permissions-Policy")).to be false
    end
  end
end
