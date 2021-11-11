describe "Acceptance::ServicePerformance", type: :feature do
  include RSpecFrontendServiceMixin

  describe "get . find-energy-certificate/service-performance" do
    let(:response) do
      get "http://find-energy-certificate.epb-frontend/service-performance"
    end

    before do
      ServicePerformance::Stub.statistics
    end

    it "has the correct title" do
      expect(response.body).to include("<title>Service Performance</title>")
    end
  end
end
