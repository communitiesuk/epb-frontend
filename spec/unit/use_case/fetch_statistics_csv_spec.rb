describe UseCase::FetchStatisticsCsv do
  include RSpecUnitMixin

  let(:statistics_gateway) { Gateway::StatisticsGateway.new(get_api_client) }
  let(:co2_gateway) { Gateway::AverageCo2EmissionsGateway.new(get_warehouse_api_client) }
  let(:fetch_statistics) { described_class.new(statistics_gateway:, co2_gateway:) }
  let(:api_data) { ServicePerformance::MonthsStatsDataStub.get_data }

  before do
    allow(statistics_gateway).to receive(:fetch).and_return(api_data)
    allow(co2_gateway).to receive(:fetch).and_return(ServicePerformance::AverageCo2EmissionsStub.body)
  end

  context "when converting statistics data from the API to format for the csv" do
    context "when no filter is passed" do
      let(:results) { fetch_statistics.execute }

      it "groups the data by months into an array of 2 hashes for all month" do
        expect(results.length).to eq(2)
        expect(results.first).to be_a(Hash)
        expect(results.first["SAPs Lodged"]).to eq 21_163
      end
    end

    context "when filtering for England" do
      let(:results) { fetch_statistics.execute("england") }

      it "groups the data by months into an array of 2 hashes" do
        expect(results.length).to eq(2)
        expect(results.first).to be_a(Hash)
        expect(results.first["SAPs Lodged"]).to eq 20_489
      end
    end
  end
end
