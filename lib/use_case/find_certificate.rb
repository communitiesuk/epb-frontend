# frozen_string_literal: true

module UseCase
  class FindCertificate
    class PostcodeNotRegistered < RuntimeError; end
    class PostcodeNotValid < RuntimeError; end
    class AuthTokenMissing < RuntimeError; end

    def initialize(assessors_gateway)
      @certificates_gateway = assessors_gateway
    end

    def execute(postcode)
      gateway_response = @certificates_gateway.search(postcode)

      if gateway_response.include?(:errors)
        gateway_response[:errors].each do |error|
          raise PostcodeNotRegistered if error[:code] == 'NOT_FOUND'
          raise PostcodeNotValid if error[:code] == 'INVALID_REQUEST'
          raise AuthTokenMissing if error[:code] == 'Auth::Errors::TokenMissing'
        end
      end

      gateway_response[:results]
    end
  end
end
