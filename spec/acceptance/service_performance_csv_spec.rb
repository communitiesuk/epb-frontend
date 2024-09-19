describe "Acceptance::ServicePerformanceCSV", type: :feature do
  include RSpecFrontendServiceMixin

  def stats_web_mock(body)
    WebMock
      .stub_request(
        :get,
        "http://test-api.gov.uk/api/statistics",
      )
      .to_return(status: 200, body: body.to_json)
  end

  def file_name_from_header
    response.original_headers["Content-Disposition"].match(/filename=("?)(.+)\1/)[2]
  end

  describe "get . find-energy-certificate/service-performance/download-csv" do
    let(:response) do
      get "http://find-energy-certificate.epb-frontend/service-performance/download-csv"
    end

    let(:parsed_data) do
      CSV.parse(response.body, headers: true)
    end

    before do
      stats_web_mock(ServicePerformance::MonthsStatsDataStub.get_data)
    end

    it "return a response 200 response" do
      expect(response.status).to eq(200)
    end

    it "has a content type header for csv" do
      expect(response.original_headers["Content-Type"]).to eq("application/csv")
    end

    it "the csv file name is correct" do
      expect(file_name_from_header).to eq("service-performance-all-regions.csv")
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
        stub[:data][:assessments][:all] = stub[:data][:assessments][:all].sort_by { |hash| hash["month"] }
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
        parsed_data.select { |row| row["Month"] == "Oct-2021" }.first.to_hash
      end

      it "produces a csv with empty cell in the row for DEC lodged" do
        expect(october_data["DECs Lodged"]).to be_nil
      end

      it "produces a csv with filled cells in the row CEPC average rating and DEC-RR lodged" do
        expect(october_data["Average CEPC Energy Rating"]).to eq("67.36")
        expect(october_data["DEC-RRs Lodged"]).to eq("470")
      end
    end
  end

  describe "get . find-energy-certificate/service-performance/download-csv?country=england" do
    let(:response) do
      get "http://find-energy-certificate.epb-frontend/service-performance/download-csv?country=england"
    end

    let(:parsed_data) do
      CSV.parse(response.body, headers: true)
    end

    before do
      stats_web_mock(ServicePerformance::MonthsStatsDataStub.get_data)
    end

    it "return a response 200 response" do
      expect(response.status).to eq(200)
    end

    it "has a content type header for csv" do
      expect(response.original_headers["Content-Type"]).to eq("application/csv")
    end

    it "the csv file name is correct" do
      expect(file_name_from_header).to eq("service-performance-england.csv")
    end

    it "has a csv with the correct headers" do
      expect(response.body).to match(/Month,SAPs Lodged,Average SAP Energy Rating,RdSAPs Lodged,Average RdSAP Energy Rating,CEPCs Lodged,Average CEPC Energy Rating,DECs Lodged,DEC-RRs Lodged,AC-CERTs Lodged/)
    end

    it "has a csv with the correct body" do
      expect(response.body).to match(/Oct-2021,20489,78.4,120045,61.73,8074,67.33,2781,462,1206/)
    end

    it "produces a data set with correct number of rows" do
      expect(parsed_data.length).to eq(2)
    end
  end

  describe "get . find-energy-certificate/service-performance/download-csv?country=northern-ireland" do
    let(:response) do
      get "http://find-energy-certificate.epb-frontend/service-performance/download-csv?country=northern-ireland"
    end

    let(:parsed_data) do
      CSV.parse(response.body, headers: true)
    end

    before do
      stats_web_mock(ServicePerformance::MonthsStatsDataStub.get_data)
    end

    it "return a response 200 response" do
      expect(response.status).to eq(200)
    end

    it "has a content type header for csv" do
      expect(response.original_headers["Content-Type"]).to eq("application/csv")
    end

    it "the csv file name is correct" do
      expect(file_name_from_header).to eq("service-performance-northern-ireland.csv")
    end

    it "has a csv with the correct headers" do
      expect(response.body).to match(/Month,SAPs Lodged,Average SAP Energy Rating,RdSAPs Lodged,Average RdSAP Energy Rating,CEPCs Lodged,Average CEPC Energy Rating,DECs Lodged,DEC-RRs Lodged,AC-CERTs Lodged/)
    end

    it "has a csv with the correct body" do
      expect(response.body).to match(/Oct-2021,674,81.7,2349,61.11,134,90.5,38,8,45/)
    end

    it "produces a data set with correct number of rows" do
      expect(parsed_data.length).to eq(2)
    end
  end
end
