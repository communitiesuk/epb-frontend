describe Gateway::StatisticsGateway do
  include RSpecUnitMixin

  let(:gateway) { described_class.new(get_api_client) }

  describe "#fetch" do
    let(:response) { gateway.fetch }

    before do
      ServicePerformance::Stub.statistics
    end

    it "calls the method and returns the expected json" do
      expect(response[:data].length).to eq(17)
      expect(response[:data].first).to match hash_including({ assessmentType: "CEPC", month: "11-2020", numAssessments: 144_533, ratingAverage: 71.85 })
    end
  end
end
