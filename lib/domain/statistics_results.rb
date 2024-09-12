module Domain
  class StatisticsResults
    attr_accessor :results

    def initialize(register_data:, warehouse_data:)
      @register_data = register_data
      @warehouse_data = warehouse_data
      @results = nil
    end

    def match_date_and_country(month:, country:)
      @warehouse_data.select { |i| i[:yearMonth] == month && i[:country] == country.to_s.underscore.titleize }
    end

    def avg_co2(matched_date_and_country:)
      matched_date_and_country.empty? ? nil : matched_date_and_country.first[:average_co2].round(2)
    end

    def update(epc_by_country:, avg_co2:, date:)
      epc_by_country.select { |row| row[:month] == date }.first[:avgCo2Emission] = avg_co2
    end

    def set_results
      @results = @register_data
      @results.each do |country, v|
        epc_by_country = v.select { |i| i[:assessmentType] == "SAP" }
        epc_by_country.each do |row|
          matching_value = match_date_and_country(month: row[:month], country:)
          update(epc_by_country:, avg_co2: avg_co2(matched_date_and_country: matching_value), date: row[:month])
        end
      end
    end

    def grouped_by_assessment_type_and_country
      @results[:assessments] =
        merged_regions = @results.flatten(2).reject { |e| e.is_a?(Symbol) }
      merged_regions.each { |h| h[:country] = "all" unless h.key?(:country) }

      grouped_by_assessment_type = merged_regions.group_by { |h| h[:assessmentType] }
      grouped_by_assessment_type.transform_values do |stats_for_assessment_type|
        stats_for_assessment_type.group_by { |stats| stats[:country] }
      end
    end

    def get_results
      results = { assessments: @results }
      results[:assessments][:grouped] = grouped_by_assessment_type_and_country
      results
    end
  end
end
