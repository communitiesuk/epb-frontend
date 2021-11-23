# frozen_string_literal: true

module UseCase
  class FetchStatistics < UseCase::Base
    def execute
      results = @gateway.fetch

      results[:grouped] = results[:data][:all].group_by { |h| h[:assessmentType] }
      results
    end
  end
end
