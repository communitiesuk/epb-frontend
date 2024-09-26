require "csv"

shared_context "when request service performance csv" do
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

  def expected_header
    ["Month", "SAPs Lodged", "Average SAP Energy Rating", "Average SAP CO2/sqm emissions", "RdSAPs Lodged", "Average RdSAP Energy Rating", "Average RdSAP CO2/sqm emissions", "CEPCs Lodged", "Average CEPC Energy Rating", "DECs Lodged", "DEC-RRs Lodged", "AC-CERTs Lodged"]
  end

  def response_csv_header(body)
    header = body.split("\n").first
    header.split(",")
  end
end

describe "Acceptance::ServicePerformanceCSV", type: :feature do
  include RSpecFrontendServiceMixin
  include_context "when request service performance csv"

  before do
    stats_web_mock(ServicePerformance::MonthsStatsDataStub.get_data)
    ServicePerformance::AverageCo2EmissionsStub.statistics
  end

  let(:parsed_data) do
    CSV.parse(response.body, headers: true)
  end

  describe "get . find-energy-certificate/service-performance/download-csv" do
    let(:response) do
      get "http://find-energy-certificate.epb-frontend/service-performance/download-csv"
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

    it "has a csv with the correct body" do
      expect(CSV.parse(response.body)).to eq CSV.parse(ServicePerformance::CsvStub.all_regions.strip!)
    end

    context "when calling the page with data in a different order" do
      before do
        stub = ServicePerformance::MonthsStatsDataStub.get_data
        stub[:data][:assessments][:all] = stub[:data][:assessments][:all].sort_by { |hash| hash["month"] }
        stats_web_mock stub
      end

      it "has a csv with the headers in the expected order" do
        expect(response_csv_header(response.body)).to eq expected_header
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

    it "return a response 200 response" do
      expect(response.status).to eq(200)
    end

    it "has a content type header for csv" do
      expect(response.original_headers["Content-Type"]).to eq("application/csv")
    end

    it "the csv file name is correct" do
      expect(file_name_from_header).to eq("service-performance-england.csv")
    end

    it "has a csv with the correct body" do
      expect(CSV.parse(response.body)).to eq CSV.parse(ServicePerformance::CsvStub.england.strip!)
    end
  end

  describe "get . find-energy-certificate/service-performance/download-csv?country=northern-ireland" do
    let(:response) do
      get "http://find-energy-certificate.epb-frontend/service-performance/download-csv?country=northern-ireland"
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

    it "has a csv with the correct body" do
      expect(CSV.parse(response.body)).to eq CSV.parse(ServicePerformance::CsvStub.northern_ireland.strip!)
    end
  end
end
