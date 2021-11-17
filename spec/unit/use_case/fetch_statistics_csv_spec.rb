describe UseCase::FetchStatisticsCsv do
  include RSpecUnitMixin

  context "when converting statistics data from the API to format for the csv" do
    let(:statistics_gateway) { instance_double(Gateway::StatisticsGateway) }
    let(:api_data) do
      { data: [
        {
          "numAssessments": 21_163,
          "assessmentType": "SAP",
          "ratingAverage": 78.41,
          "month": "2021-10",
        },
        {
          "numAssessments": 122_394,
          "assessmentType": "RdSAP",
          "ratingAverage": 61.71,
          "month": "2021-10",
        },
        {
          "numAssessments": 8208,
          "assessmentType": "CEPC",
          "ratingAverage": 67.36,
          "month": "2021-10",
        },
        {
          "numAssessments": 2189,
          "assessmentType": "DEC",
          "ratingAverage": 0.0,
          "month": "2021-10",
        },

        {
          "numAssessments": 470,
          "assessmentType": "DEC-RR",
          "ratingAverage": 0.0,
          "month": "2021-10",
        },

        {
          "numAssessments": 1251,
          "assessmentType": "AC-CERT",
          "ratingAverage": 0.0,
          "month": "2021-10",
        },

        {
          "numAssessments": 24_477,
          "assessmentType": "SAP",
          "ratingAverage": 77.83,
          "month": "2021-09",
        },
        {
          "numAssessments": 121_499,
          "assessmentType": "RdSAP",
          "ratingAverage": 61.71,
          "month": "2021-09",
        },
        {
          "numAssessments": 7718,
          "assessmentType": "CEPC",
          "ratingAverage": 68.27,
          "month": "2021-09",
        },
        {
          "numAssessments": 3500,
          "assessmentType": "DEC",
          "ratingAverage": 67.36,
          "month": "2021-09",
        },

        {
          "numAssessments": 428,
          "assessmentType": "DEC-RR",
          "ratingAverage": 0.0,
          "month": "2021-09",
        },

        {
          "numAssessments": 918,
          "assessmentType": "AC-CERT",
          "ratingAverage": 0.0,
          "month": "2021-09",
        },
      ] }
    end

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
