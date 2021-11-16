# frozen_string_literal: true

module UseCase
  class FetchStatisticsCsv < UseCase::Base
    def execute
      results = @gateway.fetch
      results[:data].group_by { |h| h[:month] }

    end
  end
end
