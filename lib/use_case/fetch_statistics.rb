# frozen_string_literal: true

module UseCase
  class FetchStatistics < UseCase::Base
    def execute
      api_data = @gateway.fetch[:data]
      results = { assessments: api_data[:assessments] }
      results[:assessments][:grouped] = grouped_by_assessment_type_and_country(results[:assessments])
      results[:user_satisfaction] = api_data[:customer]
      results
    end

  private

    def grouped_by_assessment_type_and_country(results)
      merged_regions = results.flatten(2).reject { |e| e.is_a?(Symbol) }
      merged_regions.each { |h| h[:country] = "all" unless h.key?(:country) }

      grouped_by_assessment_type = merged_regions.group_by { |h| h[:assessmentType] }
      grouped_by_assessment_type.transform_values do |stats_for_assessment_type|
        stats_for_assessment_type.group_by { |stats| stats[:country] }
      end
    end
  end
end
