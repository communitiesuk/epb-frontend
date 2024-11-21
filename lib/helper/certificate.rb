module Helper
  class Certificate
    def self.hide_bills_text?(assessment)
      assessment[:heatingCostCurrent]&.chomp(".00") == "0" ||
        assessment[:heatingCostPotential]&.chomp(".00") == "0" ||
        assessment[:hotWaterCostCurrent]&.chomp(".00") == "0" ||
        assessment[:hotWaterCostPotential]&.chomp(".00") == "0" ||
        assessment[:lightingCostCurrent]&.chomp(".00") == "0" ||
        assessment[:lightingCostPotential]&.chomp(".00") == "0" ||
        assessment[:estimatedEnergyCost].nil? ||
        assessment[:potentialEnergySaving].nil?
    end

    def self.hide_heating_demand?(assessment)
      return true if assessment[:heatDemand].nil?

      assessment[:heatDemand][:currentWaterHeatingDemand].nil? && assessment[:heatDemand][:currentSpaceHeatingDemand].nil?
    end

    def self.hide_smart_meters?(assessment)
      assessment[:gasSmartMeterPresent].nil? || assessment[:electricitySmartMeterPresent].nil? ? true : false
    end

    def self.hide_home_upgrade?(assessment)
      main_heating_hash = (assessment[:propertySummary]&.select { |item| item[:name] == "main_heating" })&.first
      energy_band = assessment[:currentEnergyEfficiencyBand]

      unless main_heating_hash.nil? || energy_band.nil?
        main_heating_bool = main_heating_hash[:description]&.include? "boiler"
        energy_band_bool = %w[a b c].any? { |rating| energy_band&.include? rating }

        return (main_heating_bool == true) || (energy_band_bool == true) ? true : false
      end
      false
    end

    def self.hide_if_rating_higher_than_d?(assessment)
      %w[a b c].any? { |rating| assessment[:currentEnergyEfficiencyBand]&.include? rating }
    end

    def self.hide_bus?(assessment)
      main_heating_hash = (assessment[:propertySummary]&.select { |item| item[:name] == "main_heating" })&.first

      unless main_heating_hash.nil?
        return main_heating_hash[:description]&.include? "heat pump"
      end

      false
    end
  end
end
