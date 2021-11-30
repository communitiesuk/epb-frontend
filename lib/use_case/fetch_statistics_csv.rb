# frozen_string_literal: true

module UseCase
  class FetchStatisticsCsv < UseCase::Base
    def execute(country = "all")
      data = @gateway.fetch[:data][:assessments]
      results = case country
                when "england-wales"
                  data[:englandWales]
                when "northern-ireland"
                  data[:northernIreland]
                else
                  data[:all]
                end
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
        end
        return_array << hash
      end
      return_array
    end
  end
end
