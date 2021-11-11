describe UseCase::FetchStatistics do
  include RSpecUnitMixin

  context "when extracting statistics data from the API" do
    let(:statistics_gateway) { Gateway::StatisticsGateway.new(get_api_client) }
    let(:fetch_statistics) { described_class.new(statistics_gateway) }
    let(:results) { fetch_statistics.execute }

    before do
      ServicePerformance::Stub.statistics
    end

    it "calls the gateway method and returns the expected json" do
      expect(results[:data].length).to eq(17)
      expect(results[:data].first).to match hash_including({ assessmentType: "CEPC", monthYear: "11-2020", numAssessments: 144_533, ratingAverage: 71.85 })
    end
  end
end
