describe UseCase::FetchStatisticsCsv do
  include RSpecUnitMixin

  context "when converting statistics data from the API to format for the csv" do
    let(:statistics_gateway) { instance_double(Gateway::StatisticsGateway) }
    let(:api_data) { ServicePerformance::MonthsStatsDataStub.get_data }

    let(:expectation) do
      [{ "Month" => "Oct-2021",
         "SAPs Lodged" => 21_163,
         "Average SAP Energy Rating" => 78.41,
         "RdSAPs Lodged" => 122_394,
         "Average RdSAP Energy Rating" => 61.71,
         "CEPCs Lodged" => 8208,
         "Average CEPC Energy Rating" => 67.36,
         "DECs Lodged" => 2189,
         "DEC-RRs Lodged" => 470,
         "AC-CERTs Lodged" => 1251 },
       { "Month" => "Sep-2021",
         "SAPs Lodged" => 24_477,
         "Average SAP Energy Rating" => 77.83,
         "RdSAPs Lodged" => 121_499,
         "Average RdSAP Energy Rating" => 61.71,
         "CEPCs Lodged" => 7718,
         "Average CEPC Energy Rating" => 68.27,
         "DECs Lodged" => 3500,
         "DEC-RRs Lodged" => 428,
         "AC-CERTs Lodged" => 918 }]
    end
    let(:fetch_statistics) { described_class.new(statistics_gateway) }
    let(:results) { fetch_statistics.execute }

    before do
      # ServicePerformance::Stub.statistics
      # allow(statistics_gateway).to receive(:new).and_return(get_api_client)
      allow(statistics_gateway).to receive(:fetch).and_return(api_data)
    end

    it "groups the data by months " do
      expect(results).to eq(expectation)
    end
  end
end
