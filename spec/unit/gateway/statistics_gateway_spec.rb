describe Gateway::StatisticsGateway do
  include RSpecUnitMixin

  let(:gateway) { described_class.new(get_api_client) }

  describe "#fetch" do
    let(:response) { gateway.fetch }

    before do
      ServicePerformance::CountryStatsStub.statistics
    end

    it "calls the method and returns the expected json for all regions" do
      expect(response[:data][:assessments][:all].length).to eq(17)
      expect(response[:data][:assessments][:all].first).to match hash_including({ assessmentType: "CEPC", month: "2020-11", numAssessments: 144_533, ratingAverage: 71.85 })
    end

    it "returns the expected json for England" do
      expect(response[:data][:assessments][:england].length).to eq(6)
      expect(response[:data][:assessments][:england].select { |i| i[:assessmentType] == "RdSAP" }.first).to match hash_including({ assessmentType: "RdSAP",
                                                                                                                                   month: "2021-09",
                                                                                                                                   numAssessments: 121_499,
                                                                                                                                   ratingAverage: 61.7122807017544 })
    end

    it "returns the expected json for Northern Ireland" do
      expect(response[:data][:assessments][:northernIreland].length).to eq(6)
      expect(response[:data][:assessments][:northernIreland].select { |i| i[:assessmentType] == "RdSAP" }.first).to match hash_including({ assessmentType: "RdSAP",
                                                                                                                                           month: "2021-09",
                                                                                                                                           numAssessments: 5779,
                                                                                                                                           ratingAverage: 59.1234156 })
    end

    it "contains the the expected countries" do
      assessments = response[:data][:assessments]
      %i[england wales northernIreland other].each do |country|
        expect(assessments.key?(country)).to be true
      end
    end
  end
end
