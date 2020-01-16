# frozen_string_literal: true

module UseCase
  class FindAssessor
    class PostcodeNotRegistered < RuntimeError; end
    class PostcodeNotValid < RuntimeError; end
    class SchemeNotFound < RuntimeError; end

    def initialize(assessors_gateway)
      @assessors_gateway = assessors_gateway
    end

    def execute(postcode)
      response = []

      gateway_response = @assessors_gateway.search(postcode)

      if gateway_response.include?(:errors)
        gateway_response[:errors].each do |error|
          raise PostcodeNotRegistered if error[:code] == 'NOT_FOUND'
          raise PostcodeNotValid if error[:code] == 'INVALID_REQUEST'
          raise SchemeNotFound if error[:code] == 'SCHEME_NOT_FOUND'
        end
      end

      assessors = gateway_response[:results]

      assessors.each do |assessors_details|
        assessor = assessors_details[:assessor]
        response <<
          {
            fullName: "#{assessor[:firstName]} #{assessor[:lastName]}",
            distance: assessors_details[:distance],
            accreditationScheme: assessor[:registeredBy][:name],
            schemeAssessorId: assessor[:registeredBy][:schemeId],
            telephoneNumber: assessor[:contactDetails][:telephoneNumber],
            email: assessor[:contactDetails][:email]
          }
      end

      response
    end
  end
end
