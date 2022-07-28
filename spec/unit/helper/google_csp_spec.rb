describe Helper::GoogleCsp do
  let(:base_options) do
    {
      script_src: "'nonce-1234567'",
      style_src: "'unsafe-inline' 'self'",
      img_src: "'self' data:",
    }
  end

  context "when GTM environment variables are defined" do
    before do
      stub_const "ENV", { "GTM_PROPERTY_FINDING" => "G-555555555" }
    end

    it "augments the passed options with GTM directives" do
      expected_options = {
        script_src: "'nonce-1234567' https://tagmanager.google.com https://*.googletagmanager.com https://www.google-analytics.com https://ssl.google-analytics.com",
        style_src: "'unsafe-inline' 'self' https://tagmanager.google.com https://fonts.googleapis.com",
        img_src: "'self' data: https://ssl.gstatic.com https://www.gstatic.com https://*.google-analytics.com https://*.googletagmanager.com https://www.google-analytics.com",
        font_src: "'self' https://fonts.gstatic.com data:",
        connect_src: "'self' https://*.google-analytics.com https://*.analytics.google.com https://*.googletagmanager.com https://www.google-analytics.com",
      }

      expect(described_class.add_options_for_google_analytics(base_options)).to eq expected_options
    end
  end

  context "when GTM environment variables are not defined" do
    it "does not augment the passed options" do
      expect(described_class.add_options_for_google_analytics(base_options)).to eq base_options
    end
  end
end
