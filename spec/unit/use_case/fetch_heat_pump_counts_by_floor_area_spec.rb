describe UseCase::FetchHeatPumpCountsByFloorArea do
  include RSpecUnitMixin

  let(:gateway) { instance_double(Gateway::HeatPumpGateway) }
  let(:use_case) { described_class.new(gateway) }

  describe "#execute" do
    before do
      allow(gateway).to receive(:count_by_floor_area).and_return(HeatPumpGateway::Stub.api_data)
    end

    it "the data from the gateway" do
      expect(use_case.execute).to eq HeatPumpGateway::Stub.api_data
    end
  end
end
