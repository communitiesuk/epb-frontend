describe Gateway::StatisticsGateway do
  include RSpecUnitMixin

  let(:gateway) { described_class.new(get_api_client) }

  describe "#fetch" do
    let(:response) { gateway.fetch }

    before do
      ServicePerformance::CountryStatsStub.statistics
    end

    it "calls the method and returns the expected json for all regions" do
      expect(response[:data][:all].length).to eq(17)
      expect(response[:data][:all].first).to match hash_including({ assessmentType: "CEPC", month: "11-2020", numAssessments: 144_533, ratingAverage: 71.85 })
    end

    it "calls the method and returns the expected json for England & Wales" do
      expect(response[:data][:englandWales].length).to eq(3)
      expect(response[:data][:englandWales].select { |i| i[:assessmentType] == "RdSAP" }.first).to match hash_including({ assessmentType: "RdSAP",
                                                                                                                          month: "09-2021",
                                                                                                                          numAssessments: 121_499,
                                                                                                                          ratingAverage: 61.7122807017544 })
    end

    it "calls the method and returns the expected json for Northern Ireland" do
      expect(response[:data][:northernIreland].length).to eq(3)
      expect(response[:data][:northernIreland].select { |i| i[:assessmentType] == "RdSAP" }.first).to match hash_including({ assessmentType: "RdSAP",
                                                                                                                             month: "09-2021",
                                                                                                                             numAssessments: 5779,
                                                                                                                             ratingAverage: 59.1234156 })
    end
  end
end
