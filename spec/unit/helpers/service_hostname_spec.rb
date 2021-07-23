describe Sinatra::FrontendService::Helpers do
  let(:frontend_service_helpers) do
    Class.new { extend Sinatra::FrontendService::Helpers }
  end

  context "when a request has 'service' contained within the hostname" do
    before do
      def frontend_service_helpers.request
        OpenStruct.new(hostname: "my-thing.service.gov.uk")
      end
    end

    it "the method uses_service_hostname returns true" do
      expect(frontend_service_helpers.uses_service_hostname?).to be true
    end
  end

  context "when a request does not have 'service' contained within the hostname" do
    before do
      def frontend_service_helpers.request
        OpenStruct.new(hostname: "my-thing.digital.fun.gov.uk")
      end
    end

    it "the method uses_service_hostname returns true" do
      expect(frontend_service_helpers.uses_service_hostname?).to be false
    end
  end
end
