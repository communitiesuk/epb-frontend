describe Gateway::AverageCo2EmissionsGateway do
  include RSpecUnitMixin

  let(:gateway) { described_class.new(get_api_client(ENV["EPB_DATA_WAREHOUSE_API_URL"])) }

  describe "getting the average co2 emissions data" do
    let(:response) { gateway.fetch }

    before { AverageCo2Emissions::Stub.get_averages }

    it "gets a response from the gateway" do
      expect(response[:data]).not_to be_nil
    end
  end
end
