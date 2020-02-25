# frozen_string_literal: true

module UseCase
  class FindAssessorByName
    class InvalidName < StandardError; end

    def initialize(assessors_gateway)
      @assessors_gateway = assessors_gateway
    end

    def execute(name)
      response = @assessors_gateway.search_by_name(name)

      response[:errors].each { |error| } if response.include?(:errors)

      response[:results]
    end
  end
end
