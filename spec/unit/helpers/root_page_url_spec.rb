describe Sinatra::FrontendService::Helpers do
  let(:frontend_service_helpers) do
    Class.new { extend Sinatra::FrontendService::Helpers }
  end

  before do
    def frontend_service_helpers.request
      OpenStruct.new(hostname: "find-energy-certificate.service.gov.uk")
    end
  end

  context "when a static start page is not configured" do
    it "resolves the root page url as '/'" do
      expect(frontend_service_helpers.root_page_url).to eq "/"
    end
  end

  context "when a static start page has been configured and the current hostname is for finding certificates" do
    static_url = "https://www.gov.uk/my-lovely-service-for-finding"

    before do
      stub_const "ENV", { "STATIC_START_PAGE_FINDING" => static_url }
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
      stub_const "ENV", { "STATIC_START_PAGE_GETTING" => static_url }
      def frontend_service_helpers.request
        OpenStruct.new(hostname: "getting-energy-certificate.service.gov.uk")
      end
    end

    it "resolves to the static start page url" do
      expect(frontend_service_helpers.root_page_url).to eq static_url
    end
  end
end
