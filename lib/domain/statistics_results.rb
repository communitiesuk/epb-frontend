module Domain
  class StatisticsResults
    attr_accessor :results

    def initialize(register_data:, warehouse_data:)
      @register_data = register_data
      @warehouse_data = warehouse_data
      @results = @register_data
    end

    def match_with_warehouse(month:, country:, assessment_type:)
      @warehouse_data[country].nil? ? [] : @warehouse_data[country].select { |i| i[:yearMonth] == month && i[:assessmentType] == assessment_type }
    end

    def avg_co2(matched_date_and_country:)
      matched_date_and_country.empty? ? nil : matched_date_and_country.first[:avgCo2Emission].round(2)
    end

    def update(list:, avg_co2:, date:, assessment_type:)
      list.select { |row| row[:month] == date && row[:assessmentType] == assessment_type }.first[:avgCo2Emission] = avg_co2 unless avg_co2.nil?
    end

    def set_results
      @results.each do |country, v|
        list = v.select { |i| i[:assessmentType] == "SAP" || i[:assessmentType] == "RdSAP" }
        list.each do |row|
          matching_value = match_with_warehouse(month: row[:month], country:, assessment_type: row[:assessmentType])
          update(list:, avg_co2: avg_co2(matched_date_and_country: matching_value), date: row[:month], assessment_type: row[:assessmentType])
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
