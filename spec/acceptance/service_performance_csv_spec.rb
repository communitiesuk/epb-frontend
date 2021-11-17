describe "Acceptance::ServicePerformanceCSV", type: :feature do
  include RSpecFrontendServiceMixin

  let(:response) do
    get "http://find-energy-certificate.epb-frontend/service-performance/download-csv"
  end

  def stats_web_mock(body)
    WebMock
      .stub_request(
        :get,
        "http://test-api.gov.uk/api/statistics",
      )
      .to_return(status: 200, body: body.to_json)
  end

  describe "get . find-energy-certificate/service-performance/download-csv" do
    before do
      stats_web_mock(ServicePerformance::MonthsStatsDataStub.get_data)
    end

    let(:parsed_data) do
      CSV.parse(response.body, headers: true)
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

    it "produces a data set with correct number of rows" do
      expect(parsed_data.length).to eq(2)
    end

    context "when calling the page with data in a different order" do
      before do
        stub = ServicePerformance::MonthsStatsDataStub.get_data
        stub[:data] = stub[:data].sort_by { |hash| hash["month"] }
        stats_web_mock stub
      end

      it "has a csv with the headers in the expected order" do
        expect(response.body).to match(/Month,SAPs Lodged,Average SAP Energy Rating,RdSAPs Lodged,Average RdSAP Energy Rating,CEPCs Lodged,Average CEPC Energy Rating,DECs Lodged,DEC-RRs Lodged,AC-CERTs Lodged/)
      end
    end

    context "when calling the page with data that has a DEC missing for October 2021" do
      before do
        stub = ServicePerformance::MissingStatsStub.get_data
        stats_web_mock(stub)
      end

      let(:october_data) do
        parsed_data = CSV.parse(response.body, headers: true)
        parsed_data.select { |row| row["Month"] == "Oct-2021" }.first
      end

      it "produces a csv with empty cell in the row position for DEC lodged and DEC average rating" do
        expect(october_data[7]).to eq(nil)
        expect(october_data[8]).to eq(nil)
      end

      it "produces a csv with filled cells in the row position for CEPC average rating and AC-CERT lodged" do
        expect(october_data[6]).to eq("67.36")
        expect(october_data[9]).to eq("470")
      end
    end
  end
end
