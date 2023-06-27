describe Helper::Certificate do
  let(:helper) { described_class }

  describe "#hide_bills_text?" do
    context "when all the attributes are null or empty" do
      let(:assessment) do
        {
          heatingCostCurrent: "0",
          heatingCostPotential: "0",
          lightingCostCurrent: "0",
          estimatedEnergyCost: "0",
          potentialEnergySaving: nil,
        }
      end

      it "returns true" do
        expect(helper.hide_bills_text?(assessment)).to eq true
        assessment[:heatingCostCurrent] = nil
        assessment[:estimatedEnergyCost] = nil
        expect(helper.hide_bills_text?(assessment)).to eq true
      end
    end

    context "when the attributes has positive values" do
      let(:assessment) do
        {
          heatingCostCurrent: "1",
          heatingCostPotential: "1",
          lightingCostCurrent: "1",
          estimatedEnergyCost: "1",
          potentialEnergySaving: "2",
        }
      end

      it "returns false" do
        expect(helper.hide_bills_text?(assessment)).to eq false
      end
    end
  end

  describe "#hide_heating_demand?" do
    context "when all the attributes are null or empty" do
      let(:assessment) do
        {
          heatDemand: { currentWaterHeatingDemand: nil, currentSpaceHeatingDemand: nil  },
        }
      end

      it "returns false" do
        expect(helper.hide_heating_demand?(assessment)).to eq true
        assessment[:currentSpaceHeatingDemand] = "5"
        expect(helper.hide_heating_demand?(assessment)).to eq true
        assessment[:heatDemand] = nil
        expect(helper.hide_heating_demand?(assessment)).to eq true
      end
    end

    context "when the attributes have positive values" do
      let(:assessment) do
        {
          heatDemand: { currentWaterHeatingDemand: "1", currentSpaceHeatingDemand: "4"  },
        }
      end

      it "returns false" do
        expect(helper.hide_heating_demand?(assessment)).to eq false
      end
    end
  end
end
