describe Helper::Assets do
  after do
    ENV["ASSETS_VERSION"] = nil
  end

  context "when the assets version environment variable is set" do
    assets_version = "deadbeef"

    before do
      ENV["ASSETS_VERSION"] = assets_version
    end

    it "uses the assets version in an asset path when calling #path" do
      expect(described_class.path("/app.css")).to eq "/static/deadbeef/app.css"
    end

    it "sets up static cache control with an s-max-age of a week when #setup_cache_control is invoked" do
      app = class_double FrontendService
      allow(app).to receive(:set)
      described_class.setup_cache_control app
      expect(app).to have_received(:set).with(:static_cache_control, [:public, { max_age: 604_800 }])
    end
  end

  context "when the assets version environment variable is not set" do
    before do
      ENV["ASSETS_VERSION"] = nil
    end

    it "does not alter the path for an asset" do
      expect(described_class.path("/app_print.css")).to eq "/app_print.css"
    end

    it "does not set up static cache control when #setup_cache_control is invoked" do
      app = class_double FrontendService
      allow(app).to receive(:set)
      described_class.setup_cache_control app
      expect(app).not_to have_received(:set)
    end
  end
end
