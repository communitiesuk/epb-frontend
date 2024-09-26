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

    def get_country_results(country:)
      country_key = country == "northern-ireland" ? :northernIreland : country.to_sym
      @results.key?(country_key.to_sym) ? @results[country_key.to_sym] : @results[:all]
    end

    def to_csv_hash(country:)
      results = get_country_results(country:)
      return_array = []
      months = results.group_by { |h| h[:month] }.keys
      types = %w[SAP RdSAP CEPC DEC DEC-RR AC-CERT]
      months.each do |month|
        hash = { "Month" => Date.parse("#{month}-01").strftime("%b-%Y") }
        types.each do |type|
          stats_item = results.select { |item| item[:month] == month && item[:assessmentType] == type }.first
          hash["#{type}s Lodged"] = !stats_item.nil? && stats_item.key?(:numAssessments) && !stats_item[:numAssessments].nil? ? stats_item[:numAssessments] : nil
          if %w[SAP RdSAP CEPC].include?(type) && !stats_item.nil?
            hash["Average #{type} Energy Rating"] = stats_item.key?(:ratingAverage) && !stats_item[:ratingAverage].nil? ? stats_item[:ratingAverage].round(2) : nil
          end
          if %w[SAP RdSAP].include?(type) && !stats_item.nil? && country != "other"
            hash["Average #{type} CO2/sqm emissions"] = stats_item.key?(:avgCo2Emission) && !stats_item[:avgCo2Emission].nil? ? stats_item[:avgCo2Emission].round(2) : nil
          end
        end
        return_array << hash
      end
      return_array
    end
  end
end
