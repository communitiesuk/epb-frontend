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

      (assessment[:heatDemand][:currentWaterHeatingDemand].nil? && assessment[:heatDemand][:currentSpaceHeatingDemand].nil?)
    end
  end
end
