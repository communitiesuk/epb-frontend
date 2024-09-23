describe UseCase::FetchStatistics do
  include RSpecUnitMixin

  context "when extracting statistics data from both APIs" do
    let(:statistics_gateway) { Gateway::StatisticsGateway.new(get_api_client) }
    let(:co2_gateway) { Gateway::AverageCo2EmissionsGateway.new(get_warehouse_api_client) }
    let(:fetch_statistics) { described_class.new(statistics_gateway:, co2_gateway:) }
    let(:results) { fetch_statistics.execute }

    before do
      ServicePerformance::CountryStatsStub.statistics
      ServicePerformance::AverageCo2EmissionsStub.statistics
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
    end

    it "expects SAPs to have average CO2 emissions" do
      england_result = results[:assessments][:grouped]["SAP"]["England"]
      expect(england_result.first[:avgCo2Emission]).to eq 15
    end
  end

  context "when the data warehouse returns no data" do
    let(:statistics_gateway) { Gateway::StatisticsGateway.new(get_api_client) }
    let(:co2_gateway) { Gateway::AverageCo2EmissionsGateway.new(get_warehouse_api_client) }
    let(:fetch_statistics) { described_class.new(statistics_gateway:, co2_gateway:) }

    before do
      ServicePerformance::CountryStatsStub.statistics
      ServicePerformance::EmptyAverageCo2EmissionsStub.statistics
    end

    it "to not raise error" do
      expect { fetch_statistics.execute }.not_to raise_error
    end
  end
end
