# frozen_string_literal: true

module UseCase
  class FetchStatistics < UseCase::Base
    def execute
      results = @gateway.fetch

      results[:grouped] = grouped_by_assessment_type_and_country(results)
      results
    end

  private

    def grouped_by_assessment_type_and_country(results)
      merged_regions = results[:data].flatten(2).reject { |e| e.is_a?(Symbol) }
      merged_regions.each { |h| h[:country] = "all" unless h.key?(:country) }

      grouped_by_assessment_type = merged_regions.group_by { |h| h[:assessmentType] }
      grouped_by_assessment_type.transform_values do |stats_for_assessment_type|
        stats_for_assessment_type.group_by { |stats| stats[:country] }
      end
    end
  end
end
