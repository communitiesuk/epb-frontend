describe UseCase::FetchStatistics do
  include RSpecUnitMixin

  context "when extracting statistics data from the API" do
    let(:statistics_gateway) { Gateway::StatisticsGateway.new(get_api_client) }
    let(:fetch_statistics) { described_class.new(statistics_gateway) }
    let(:results) { fetch_statistics.execute }

    before do
      ServicePerformance::CountryStatsStub.statistics
    end

    it "calls the gateway method and returns the expected json" do
      expect(results[:data][:all].length).to eq(17)
      cepc = results[:data][:all].select { |i| i[:assessmentType] == "CEPC" && i[:month] == "11-2020" }

      expect(cepc.first).to eq({ assessmentType: "CEPC", month: "11-2020", numAssessments: 144_533, ratingAverage: 71.85 })
    end

    it "groups the data by the assessment types for iterating in the erb" do
      assessment_types = %w[SAP RdSAP CEPC DEC AC-CERT DEC-RR]
      expect(results[:grouped].length).to eq(assessment_types.length)
      expect(results[:grouped].keys - assessment_types).to eq([])

      pp results[:grouped]
      expect(results[:grouped]["CEPC"]).to eq([{ numAssessments: 144_533,
                                                 assessmentType: "CEPC",
                                                 ratingAverage: 71.85,
                                                 month: "11-2020" },
                                               { numAssessments: 2837,
                                                 assessmentType: "CEPC",
                                                 ratingAverage: 66.24,
                                                 month: "11-2021" },
                                               { numAssessments: 6514,
                                                 assessmentType: "CEPC",
                                                 ratingAverage: 72.843537414966,
                                                 month: "02-2021" }])
    end
  end
end
