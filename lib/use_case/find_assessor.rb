# frozen_string_literal: true

module UseCase
  class FindAssessor
    class PostcodeNotRegistered < RuntimeError; end
    class PostcodeNotValid < RuntimeError; end

    def initialize(assessors_gateway)
      @assessors_gateway = assessors_gateway
    end

    def execute(postcode)
      gateway_response = @assessors_gateway.search(postcode)

      if gateway_response.include?(:errors)
        gateway_response[:errors].each do |error|
          raise PostcodeNotRegistered if error[:code] == 'NOT_FOUND'
          raise PostcodeNotValid if error[:code] == 'INVALID_REQUEST'
        end
      end

      gateway_response[:results]
    end
  end
end
