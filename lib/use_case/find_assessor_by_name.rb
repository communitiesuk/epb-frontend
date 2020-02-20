# frozen_string_literal: true

module UseCase
  class FindAssessorByName
    class TooManyResults < StandardError; end
    class InvalidName < StandardError; end

    def initialize(assessors_gateway)
      @assessors_gateway = assessors_gateway
    end

    def execute(name)
      response = @assessors_gateway.search_by_name(name)

      if response.include?(:errors)
        response[:errors].each do |error|
          raise TooManyResults if error[:code] == 'TOO_MANY_RESULTS'
        end
      end

      response[:results]
    end
  end
end
