describe "Acceptance::ServicePerformanceCSV", type: :feature do
  include RSpecFrontendServiceMixin

  describe "get . find-energy-certificate/service-performance/download-csv" do
    let(:response) do
      get "http://find-energy-certificate.epb-frontend/service-performance/download-csv"
    end

    before do
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/statistics",
        )
        .to_return(status: 200, body: ServicePerformance::MonthsStatsDataStub.get_data.to_json)
    end

    it "return a response 200 response" do
      expect(response.status).to eq(200)
    end

    it "has a content type header for csv" do
      expect(response.original_headers["Content-Type"]).to eq("application/csv")
    end

    it "has a csv with the correct headers" do
      expect(response.body).to match(/Month,SAPs Lodged,Average SAP Energy Rating,RdSAPs Lodged,Average RdSAP Energy Rating,CEPCs Lodged,Average CEPC Energy Rating,DECs Lodged,DEC-RRs Lodged,AC-CERTs Lodged/)
    end

    it "has a csv with the correct body" do
      expect(response.body).to match(/Oct-2021,21163,78.41,122394,61.71,8208,67.36,2189,470,1251/)
    end
  end
end
