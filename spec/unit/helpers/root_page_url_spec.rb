describe "Helpers.root_page_url", type: :helper do
  let(:frontend_service_helpers) do
    Class.new { extend Helpers }
  end

  before do
    I18n.locale = I18n.default_locale
    def frontend_service_helpers.request
      OpenStruct.new(hostname: "find-energy-certificate.service.gov.uk")
    end
  end

  after do
    def frontend_service_helpers.params
      { "lang" => "en" }
    end
    frontend_service_helpers.set_locale
  end

  context "when a static start page is not configured" do
    it "resolves the root page url as '/'" do
      expect(frontend_service_helpers.root_page_url).to eq "/"
    end
  end

  context "when a static start page has been configured and the current hostname is for finding certificates" do
    static_url = "https://www.gov.uk/my-lovely-service-for-finding"

    before do
      stub_const "ENV", { "STATIC_START_PAGE_FINDING_EN" => static_url }
      def frontend_service_helpers.request
        OpenStruct.new(hostname: "find-energy-certificate.service.gov.uk")
      end
    end

    it "resolves to the static start page url" do
      expect(frontend_service_helpers.root_page_url).to eq static_url
    end
  end

  context "when a static start page has been configured and the current hostname is for getting certificates" do
    static_url = "https://www.gov.uk/my-lovely-service-for-getting"

    before do
      stub_const "ENV", { "STATIC_START_PAGE_GETTING_EN" => static_url }
      def frontend_service_helpers.request
        OpenStruct.new(hostname: "getting-energy-certificate.service.gov.uk")
      end
    end

    it "resolves to the static start page url" do
      expect(frontend_service_helpers.root_page_url).to eq static_url
    end
  end

  context "when a static start page has been configured, the current hostname is for finding certificates, and the lang of the request indicates Welsh" do
    static_url = "https://www.gov.uk/fy-ngwasanaeth-hyfryd-am-ddod-o-hyd-iddo"

    before do
      stub_const "ENV", { "STATIC_START_PAGE_FINDING_CY" => static_url }
      def frontend_service_helpers.params
        { "lang" => "cy" }
      end
      frontend_service_helpers.set_locale
    end

    it "resolves to the static start page url" do
      expect(frontend_service_helpers.root_page_url).to eq static_url
    end
  end

  context "when a static start page has been configured, the current hostname is for getting certificates, and the lang of the request indicates Welsh" do
    static_url = "https://www.gov.uk/fy-ngwasanaeth-hyfryd-am-gael"

    before do
      stub_const "ENV", { "STATIC_START_PAGE_GETTING_CY" => static_url }
      def frontend_service_helpers.params
        { "lang" => "cy" }
      end

      def frontend_service_helpers.request
        OpenStruct.new(hostname: "getting-energy-certificate.service.gov.uk")
      end
      frontend_service_helpers.set_locale
    end

    it "resolves to the static start page url" do
      expect(frontend_service_helpers.root_page_url).to eq static_url
    end
  end

  context "when calling #get_service_root_page_url" do
    static_url = "https://www.gov.uk/fy-ngwasanaeth-hyfryd-am-gael"

    before do
      stub_const "ENV", { "STATIC_START_PAGE_GETTING_CY" => static_url }
      def frontend_service_helpers.params
        { "lang" => "cy" }
      end

      def frontend_service_helpers.request
        OpenStruct.new(hostname: "find-energy-certificate.service.gov.uk")
      end
      frontend_service_helpers.set_locale
    end

    it "resolves to the getting service root page url in the correct language" do
      expect(frontend_service_helpers.get_service_root_page_url).to eq static_url
    end
  end
end
