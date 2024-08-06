describe Middleware::PermissionsPolicy do
  subject(:middleware) { described_class.new(app) }

  let(:policy) { "accelerometer=(), autoplay=(), camera=(), cross-origin-isolated=(), display-capture=*, encrypted-media=*, fullscreen=*, geolocation=(), gyroscope=(), keyboard-map=(), magnetometer=(), microphone=(), midi=(), payment=(), picture-in-picture=(), publickey-credentials-get=(), screen-wake-lock=(), sync-xhr=(), usb=(), xr-spatial-tracking=()" }

  context "when the middleware is used on an HTML response" do
    let(:app) do
      app = double
      allow(app).to receive(:call).and_return([200, Rack::Headers.new.merge({ "Content-Type" => "text/html" }), "some content"])
      app
    end

    it "adds the expected Permissions-Policy header to any response" do
      _, headers, = middleware.call(nil)
      expect(headers["Permissions-Policy"]).to eq policy
    end
  end

  context "when the middleware is used on a text javascript response" do
    let(:app) do
      app = double
      allow(app).to receive(:call).and_return([200, Rack::Headers.new.merge({ "Content-Type" => "text/javascript" }), "some content"])
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
      allow(app).to receive(:call).and_return([200, Rack::Headers.new.merge({ "Content-Type" => "application/javascript" }), "some content"])
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
      allow(app).to receive(:call).and_return([200, Rack::Headers.new.merge({ "Content-Type" => "text/css" }), "body { background-color: goldenrod; }"])
      app
    end

    it "does not add a Permissions-Policy header" do
      _, headers, = middleware.call(nil)
      expect(headers.key?("Permissions-Policy")).to be false
    end
  end
end
