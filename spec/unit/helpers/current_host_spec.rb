require "ostruct"

describe "Helpers.get_subdomain_host" do
  subject(:frontend_service_helpers) do
    helpers = Class.new { extend Helpers }

    class << helpers
      attr_accessor :request, :settings
    end

    helpers.settings = settings
    helpers
  end

  let(:settings) do
    settings = Object.new
    def settings.development?
      false
    end

    settings
  end

  context "when platform is PaaS and current URL includes integration" do
    let(:request) do
      req = OpenStruct.new
      req.url = "https://find-energy-certificate-integration.somehost.com/"
      req
    end

    let(:subdomain) { "find-energy-certificate" }

    before do
      frontend_service_helpers.request = request
      allow(Helper::Platform).to receive(:is_paas?).and_return true
    end

    it "returns the integration subdomain for digital.communities.gov.uk" do
      expect(frontend_service_helpers.get_subdomain_host(subdomain)).to eq "https://find-energy-certificate-integration.digital.communities.gov.uk"
    end
  end

  context "when platform is not PaaS and current URL includes staging" do
    let(:request) do
      req = OpenStruct.new
      req.url = "https://find-energy-certificate-staging.somehost.com/"
      req
    end

    let(:subdomain) { "find-energy-certificate" }

    before do
      frontend_service_helpers.request = request
      allow(Helper::Platform).to receive(:is_paas?).and_return false
    end

    it "returns the staging subdomain for centraldatastore.net" do
      expect(frontend_service_helpers.get_subdomain_host(subdomain)).to eq "https://find-energy-certificate-staging.centraldatastore.net"
    end
  end

  context "when current URL does not include integration or staging" do
    let(:request) do
      req = OpenStruct.new
      req.url = "https://find-energy-certificate.therealdomain.com/"
      req
    end

    let(:subdomain) { "getting-an-energy-certificate" }

    before do
      frontend_service_helpers.request = request
    end

    it "returns the service.gov.uk host" do
      expect(frontend_service_helpers.get_subdomain_host(subdomain)).to eq "https://getting-an-energy-certificate.service.gov.uk"
    end
  end
end
