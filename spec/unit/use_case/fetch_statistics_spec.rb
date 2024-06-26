describe UseCase::FetchStatistics do
  include RSpecUnitMixin

  context "when extracting statistics data from the API" do
    let(:statistics_gateway) { Gateway::StatisticsGateway.new(get_api_client) }
    let(:fetch_statistics) { described_class.new(statistics_gateway) }
    let(:results) { fetch_statistics.execute }

    before do
      ServicePerformance::CountryStatsStub.statistics
    end

    it "calls the gateway method and returns the expected json for assessments" do
      expect(results.keys).to eq(%i[assessments])
    end

    it "contains expected json for assessments" do
      expect(results[:assessments][:all].length).to eq(17)
      expect(results[:assessments][:england].length).to eq(6)
      expect(results[:assessments][:northernIreland].length).to eq(6)
      cepc = results[:assessments][:all].select { |i| i[:assessmentType] == "CEPC" && i[:month] == "2020-11" }

      expect(cepc.first).to eq({ assessmentType: "CEPC", month: "2020-11", numAssessments: 144_533, ratingAverage: 71.85, country: "all" })
    end

    it "groups the assessments data by the assessment types and country", :aggregate_failures do
      assessment_types = %w[SAP RdSAP CEPC DEC AC-CERT DEC-RR]
      expect(results[:assessments][:grouped].length).to eq(assessment_types.length)
      expect(results[:assessments][:grouped].keys - assessment_types).to eq([])

      expect(results[:assessments][:grouped]["CEPC"]).to eq({
        "England" => [
          { assessmentType: "CEPC", country: "England", month: "2021-09", numAssessments: 92_124, ratingAverage: 47.7122807017544 },
        ],
        "Wales" => [
          { assessmentType: "CEPC", country: "Wales", month: "2021-09", numAssessments: 874, ratingAverage: 47.7122807017544 },
        ],
        "Northern Ireland" => [
          { assessmentType: "CEPC", country: "Northern Ireland", month: "2021-09", numAssessments: 874, ratingAverage: 47.7122807017544 },
        ],
        "Other" => [
          { assessmentType: "CEPC", country: "Other", month: "2021-09", numAssessments: 26, ratingAverage: 61.7122807017544 },
        ],
        "all" => [
          { assessmentType: "CEPC", country: "all", month: "2020-11", numAssessments: 144_533, ratingAverage: 71.85 },
          { assessmentType: "CEPC", country: "all", month: "2021-11", numAssessments: 2837, ratingAverage: 66.24 },
          { assessmentType: "CEPC", country: "all", month: "2021-02", numAssessments: 6514, ratingAverage: 72.843537414966 },
        ],
      })
    end
  end
end
