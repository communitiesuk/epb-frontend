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
      country_name = assessment[:countryName]
      check_array = []

      if main_heating_hash.nil?
        return false
      else
        check_array << main_heating_hash[:description]&.downcase&.include?("boiler")
      end

      if energy_band.nil?
        return false
      else
        check_array << %w[a b c].any? { |rating| energy_band&.include? rating }
      end

      if country_name.nil?
        return false
      else
        not_in_england = !["England", "England and Wales"].include?(country_name)
        check_array << not_in_england
      end

      (check_array.include?(true) ? true : false)
    end

    def self.hide_if_rating_higher_than_d?(assessment)
      %w[a b c].any? { |rating| assessment[:currentEnergyEfficiencyBand]&.include? rating }
    end

    def self.hide_bus?(assessment)
      main_heating_hash = (assessment[:propertySummary]&.select { |item| item[:name] == "main_heating" })&.first

      unless main_heating_hash.nil?
        return main_heating_hash[:description]&.downcase&.include? "heat pump"
      end

      false
    end

    def self.hide_nest_upgrade?(assessment)
      country_name = assessment[:countryName]
      wrong_rating = %w[a b c].any? { |rating| assessment[:currentEnergyEfficiencyBand]&.include? rating }
      in_wales = ["Wales", "England and Wales"].include?(country_name)

      (wrong_rating == true) || (in_wales == false) ? true : false
    end
  end
end
