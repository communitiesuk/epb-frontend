# frozen_string_literal: true

module UseCase
  class FetchStatistics < UseCase::Base
    def execute
      @gateway.fetch
    end
  end
end
