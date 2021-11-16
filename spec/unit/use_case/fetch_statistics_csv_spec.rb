describe UseCase::FetchStatisticsCsv do
  include RSpecUnitMixin

  context "when converting statistics data from the API to format for the csv" do
    let(:statistics_gateway) { Gateway::StatisticsGateway.new(get_api_client) }
    let(:expectation) do
      [{ "Month" => "Oct-21",
         "SAPs Lodged" => 21_163,
         "Average SAP Energy Rating" => 78.41,
         "RdSAPs Lodged" => 122_394,
         "Average RdSAP Energy Rating" => 61.71,
         "CEPCs Lodged" => 8208,
         "Average CEPC Energy Rating" => 67.36,
         "DECs Lodged" => 2819,
         "Average DEC Energy Rating" => nil,
         "DEC-RRs Lodged" => 125,
         "Average DEC-RR Energy Rating" => nil,
         "AC-Reports Lodged" => 470,
         "Average AC-Report Energy Rating" => nil },
       { "Month" => "Sept-21",
         "SAPs Lodged" => 24_477,
         "Average SAP Energy Rating" => 77.83,
         "RdSAPs Lodged" => 121_499,
         "Average RdSAP Energy Rating" => 61.71,
         "CEPCs Lodged" => 7718,
         "Average CEPC Energy Rating" => 67.36,
         "DECs Lodged" => 3500,
         "Average DEC Energy Rating" => nil,
         "DEC-RRs Lodged" => 428,
         "Average DEC-RR Energy Rating" => nil,
         "AC-Reports Lodged" => 918,
         "Average AC-Report Energy Rating" => nil }]
    end
    let(:fetch_statistics) { described_class.new(statistics_gateway) }
    let(:results) { fetch_statistics.execute }

    before do
      ServicePerformance::Stub.statistics
    end

    it "groups the data by months " do
      expect(results.keys).to eq(["11-2020", "09-2021", "10-2020", "11-2021", "03-2021", "02-2021", "07-2021", "06-2021", "01-2021", "12-2020", "04-2021"])
    end
  end
end
