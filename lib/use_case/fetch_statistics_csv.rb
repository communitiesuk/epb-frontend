# frozen_string_literal: true

module UseCase
  class FetchStatisticsCsv < UseCase::Base
    def execute
      results = @gateway.fetch
      return_array = []
      months = results[:data].group_by { |h| h[:month] }.keys
      types = results[:data].group_by { |h| h[:assessmentType] }.keys
      months.each do |month|
        hash = { "Month" => Date.parse("#{month}-01").strftime("%b-%Y") }
        types.each do |type|
          stats_item = results[:data].select { |item| item[:month] == month && item[:assessmentType] == type }.first
          hash["#{type}s Lodged"] = stats_item[:numAssessments]
          if %w[SAP RdSAP CEPC].include?(type)
            hash["Average #{type} Energy Rating"] = stats_item[:ratingAverage]
          end
        end
        return_array << hash
      end
      return_array
    end
  end
end
