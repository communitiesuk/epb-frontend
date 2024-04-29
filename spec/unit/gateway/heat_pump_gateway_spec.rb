describe Gateway::HeatPumpGateway do
  include RSpecUnitMixin

  let(:gateway) { described_class.new(get_api_client(ENV["EPB_DATA_WAREHOUSE_API_URL"])) }

  describe "getting the count by floor area" do
    let(:response) { gateway.count_by_floor_area }

    before { HeatPumpGateway::Stub.count_by_floor_area }

    it "gets a response from the gateway" do
      expect(response[:data]).not_to be_nil
    end
  end
end
