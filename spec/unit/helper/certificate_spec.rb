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
        expect(helper.hide_bills_text?(assessment)).to be true
        assessment[:heatingCostCurrent] = nil
        assessment[:estimatedEnergyCost] = nil
        expect(helper.hide_bills_text?(assessment)).to be true
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
        expect(helper.hide_bills_text?(assessment)).to be false
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
        expect(helper.hide_heating_demand?(assessment)).to be true
        assessment[:currentSpaceHeatingDemand] = "5"
        expect(helper.hide_heating_demand?(assessment)).to be true
        assessment[:heatDemand] = nil
        expect(helper.hide_heating_demand?(assessment)).to be true
      end
    end

    context "when the attributes have positive values" do
      let(:assessment) do
        {
          heatDemand: { currentWaterHeatingDemand: "1", currentSpaceHeatingDemand: "4"  },
        }
      end

      it "returns false" do
        expect(helper.hide_heating_demand?(assessment)).to be false
      end
    end
  end

  describe "#hide_boiler_upgrade" do
    context "when boiler present" do
      let(:assessment) do
        {
          propertySummary: [{ name: "wall", description: "Many walls", energyEfficiencyRating: 2 },

                            { name: "secondary_heating", description: "Heating the house", energyEfficiencyRating: 5 },

                            { name: "main_heating", description: "boiler", energyEfficiencyRating: 3 },

                            { name: "roof", description: "(another dwelling above)", energyEfficiencyRating: 0 }],
          currentEnergyEfficiencyBand: "b",
          countryId: 1,
        }
      end

      it "returns true" do
        pp assessment
        expect(helper.hide_home_upgrade?(assessment)).to be true
      end
    end

    context "when boiler is not present and rating is lower than or equal to d" do
      let(:assessment) do
        {
          propertySummary: [{ name: "wall", description: "Many walls", energyEfficiencyRating: 2 },

                            { name: "secondary_heating", description: "Heating the house", energyEfficiencyRating: 5 },

                            { name: "main_heating", description: "Room heaters, electric", energyEfficiencyRating: 3 },

                            { name: "roof", description: "(another dwelling above)", energyEfficiencyRating: 0 }],
          currentEnergyEfficiencyBand: "d",
          countryId: 1,
        }
      end

      it "returns false" do
        expect(helper.hide_home_upgrade?(assessment)).to be false
      end
    end

    context "when boiler is not present and rating is lower than or equal to d but it is in wales" do
      let(:assessment) do
        {
          propertySummary: [{ name: "wall", description: "Many walls", energyEfficiencyRating: 2 },

                            { name: "secondary_heating", description: "Heating the house", energyEfficiencyRating: 5 },

                            { name: "main_heating", description: "Room heaters, electric", energyEfficiencyRating: 3 },

                            { name: "roof", description: "(another dwelling above)", energyEfficiencyRating: 0 }],
          currentEnergyEfficiencyBand: "d",
          countryId: 2,
        }
      end

      it "returns true" do
        expect(helper.hide_home_upgrade?(assessment)).to be true
      end
    end

    context "when boiler is not present or rating is higher than or equal to d" do
      let(:assessment) do
        {
          propertySummary: [{ name: "wall", description: "Many walls", energyEfficiencyRating: 2 },

                            { name: "secondary_heating", description: "Heating the house", energyEfficiencyRating: 5 },

                            { name: "main_heating", description: "Room heaters, electric", energyEfficiencyRating: 3 },

                            { name: "roof", description: "(another dwelling above)", energyEfficiencyRating: 0 }],
          currentEnergyEfficiencyBand: "b",
          countryId: 1,
        }
      end

      it "returns true" do
        expect(helper.hide_home_upgrade?(assessment)).to be true
      end
    end

    context "when boiler is present and rating is lower than or equal to d" do
      let(:assessment) do
        {
          propertySummary: [{ name: "wall", description: "Many walls", energyEfficiencyRating: 2 },

                            { name: "secondary_heating", description: "Heating the house", energyEfficiencyRating: 5 },

                            { name: "main_heating", description: "boiler", energyEfficiencyRating: 3 },

                            { name: "roof", description: "(another dwelling above)", energyEfficiencyRating: 0 }],
          currentEnergyEfficiencyBand: "e",
          countryId: 1,
        }
      end

      it "returns true" do
        expect(helper.hide_home_upgrade?(assessment)).to be true
      end
    end

    context "when boiler is present and upper case" do
      let(:assessment) do
        {
          propertySummary: [{ name: "wall", description: "Many walls", energyEfficiencyRating: 2 },

                            { name: "secondary_heating", description: "Heating the house", energyEfficiencyRating: 5 },

                            { name: "main_heating", description: "Boiler", energyEfficiencyRating: 3 },

                            { name: "roof", description: "(another dwelling above)", energyEfficiencyRating: 0 }],
          currentEnergyEfficiencyBand: "e",
          countryId: 1,
        }
      end

      it "returns true" do
        expect(helper.hide_home_upgrade?(assessment)).to be true
      end
    end

    context "when main_heating not present" do
      let(:assessment) do
        {
          propertySummary: [{ name: "wall", description: "Many walls", energyEfficiencyRating: 2 },

                            { name: "secondary_heating", description: "Heating the house", energyEfficiencyRating: 5 },

                            { name: "roof", description: "(another dwelling above)", energyEfficiencyRating: 0 }],
          countryId: 1,
          currentEnergyEfficiencyBand: "e",
        }
      end

      it "returns false" do
        expect(helper.hide_home_upgrade?(assessment)).to be false
      end
    end

    context "when property summary not present" do
      let(:assessment) do
        {
          boop: [{ name: "wall", description: "Many walls", energyEfficiencyRating: 2 },

                 { name: "secondary_heating", description: "Heating the house", energyEfficiencyRating: 5 },

                 { name: "roof", description: "(another dwelling above)", energyEfficiencyRating: 0 }],
          countryId: 1,
          currentEnergyEfficiencyBand: "e",
        }
      end

      it "returns false" do
        expect(helper.hide_home_upgrade?(assessment)).to be false
      end
    end
  end

  describe "#hide_if_rating_higher_than_d?" do
    context "when rating is higher than or equal to d" do
      let(:assessment) do
        {
          currentEnergyEfficiencyBand: "b",
        }
      end

      it "returns true" do
        expect(helper.hide_if_rating_higher_than_d?(assessment)).to be true
      end
    end

    context "when rating is lower than or equal to d" do
      let(:assessment) do
        {
          currentEnergyEfficiencyBand: "e",
        }
      end

      it "returns false" do
        expect(helper.hide_if_rating_higher_than_d?(assessment)).to be false
      end
    end

    context "when rating not present" do
      let(:assessment) do
        {
          currentEnergyEfficiencyBand: nil,
        }
      end

      it "returns false" do
        expect(helper.hide_if_rating_higher_than_d?(assessment)).to be false
      end
    end
  end

  describe "#hide_smart_meters?" do
    context "when both gas and electric smart meters are set to nil" do
      let(:assessment) do
        {
          gasSmartMeterPresent: nil,
          electricitySmartMeterPresent: nil,
        }
      end

      it "returns true" do
        expect(helper.hide_smart_meters?(assessment)).to be true
      end
    end

    context "when both gas and electric smart meters are not set to nil" do
      let(:assessment) do
        {
          gasSmartMeterPresent: true,
          electricitySmartMeterPresent: false,
        }
      end

      it "returns false" do
        expect(helper.hide_smart_meters?(assessment)).to be false
      end
    end
  end

  describe "#hide_bus?" do
    context "when main heating is boiler" do
      let(:assessment) do
        {
          propertySummary: [{ name: "wall", description: "Many walls", energyEfficiencyRating: 2 },

                            { name: "secondary_heating", description: "Heating the house", energyEfficiencyRating: 5 },

                            { name: "main_heating", description: "boiler", energyEfficiencyRating: 3 },

                            { name: "roof", description: "(another dwelling above)", energyEfficiencyRating: 0 }],
        }
      end

      it "returns false" do
        expect(helper.hide_bus?(assessment)).to be false
      end
    end

    context "when main heating is heat pump" do
      let(:assessment) do
        {
          propertySummary: [{ name: "wall", description: "Many walls", energyEfficiencyRating: 2 },

                            { name: "secondary_heating", description: "Heating the house", energyEfficiencyRating: 5 },

                            { name: "main_heating", description: "heat pump", energyEfficiencyRating: 3 },

                            { name: "roof", description: "(another dwelling above)", energyEfficiencyRating: 0 }],
        }
      end

      it "returns true" do
        expect(helper.hide_bus?(assessment)).to be true
      end
    end

    context "when main heating is heat pump and capitalised" do
      let(:assessment) do
        {
          propertySummary: [{ name: "wall", description: "Many walls", energyEfficiencyRating: 2 },

                            { name: "secondary_heating", description: "Heating the house", energyEfficiencyRating: 5 },

                            { name: "main_heating", description: "Heat Pump", energyEfficiencyRating: 3 },

                            { name: "roof", description: "(another dwelling above)", energyEfficiencyRating: 0 }],
        }
      end

      it "returns true" do
        expect(helper.hide_bus?(assessment)).to be true
      end
    end
  end

  describe "#hide_nest_upgrade" do
    context "when rating is higher than or equal to d" do
      let(:assessment) do
        {
          currentEnergyEfficiencyBand: "b",
          countryId: 2,
        }
      end

      it "returns true" do
        expect(helper.hide_nest_upgrade?(assessment)).to be true
      end
    end

    context "when rating is lower than or equal to d but not in Wales" do
      let(:assessment) do
        {
          currentEnergyEfficiencyBand: "e",
          countryId: 1,
        }
      end

      it "returns true" do
        expect(helper.hide_nest_upgrade?(assessment)).to be true
      end
    end

    context "when rating is lower than or equal to d and is in Wales" do
      let(:assessment) do
        {
          currentEnergyEfficiencyBand: "e",
          countryId: 2,
        }
      end

      it "returns false" do
        expect(helper.hide_nest_upgrade?(assessment)).to be false
      end
    end
  end
end
