describe UseCase::FetchStatisticsCsv do
  include RSpecUnitMixin

  let(:statistics_gateway) { instance_double(Gateway::StatisticsGateway) }
  let(:api_data) { ServicePerformance::MonthsStatsDataStub.get_data }
  let(:fetch_statistics) { described_class.new(statistics_gateway) }

  context "when converting statistics data from the API to format for the csv" do
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

    let(:results) { fetch_statistics.execute }

    before do
      allow(statistics_gateway).to receive(:fetch).and_return(api_data)
    end

    it "groups the data by months" do
      expect(results).to eq(expectation)
    end
  end

  context "when converting stats data for England and Wales into a csv" do
    let(:results) { fetch_statistics.execute("england-wales") }
    let(:expectation) do
      [{ "Month" => "Oct-2021",
         "SAPs Lodged" => 20_489,
         "Average SAP Energy Rating" => 78.40,
         "RdSAPs Lodged" => 120_045,
         "Average RdSAP Energy Rating" => 61.73,
         "CEPCs Lodged" => 8074,
         "Average CEPC Energy Rating" => 67.33,
         "DECs Lodged" => 2781,
         "DEC-RRs Lodged" => 462,
         "AC-CERTs Lodged" => 1206 },
       { "Month" => "Sep-2021",
         "SAPs Lodged" => 23_834,
         "Average SAP Energy Rating" => 77.82,
         "RdSAPs Lodged" => 119_033,
         "Average RdSAP Energy Rating" => 61.74,
         "CEPCs Lodged" => 7572,
         "Average CEPC Energy Rating" => 68.18,
         "DECs Lodged" => 3298,
         "DEC-RRs Lodged" => 402,
         "AC-CERTs Lodged" => 861 }]
    end

    before do
      allow(statistics_gateway).to receive(:fetch).and_return(api_data)
    end

    it "groups the data by months" do
      expect(results).to eq(expectation)
    end
  end

  context "when converting stats data for Nothern Ireland into a csv" do
    let(:results) { fetch_statistics.execute("northern-ireland") }
    let(:expectation) do
      [{ "Month" => "Oct-2021",
         "SAPs Lodged" => 674,
         "Average SAP Energy Rating" => 81.70,
         "RdSAPs Lodged" => 2349,
         "Average RdSAP Energy Rating" => 61.11,
         "CEPCs Lodged" => 134,
         "Average CEPC Energy Rating" => 90.5,
         "DECs Lodged" => 38,
         "DEC-RRs Lodged" => 8,
         "AC-CERTs Lodged" => 45 },
       { "Month" => "Sep-2021",
         "SAPs Lodged" => 643,
         "Average SAP Energy Rating" => 82.56,
         "RdSAPs Lodged" => 2466,
         "Average RdSAP Energy Rating" => 58.59,
         "CEPCs Lodged" => 146,
         "Average CEPC Energy Rating" => 79.33,
         "DECs Lodged" => 202,
         "DEC-RRs Lodged" => 26,
         "AC-CERTs Lodged" => 57 }]
    end

    before do
      allow(statistics_gateway).to receive(:fetch).and_return(api_data)
    end

    it "groups the data by months" do
      expect(results).to eq(expectation)
    end
  end
end
