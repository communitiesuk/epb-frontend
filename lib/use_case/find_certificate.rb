# frozen_string_literal: true

module UseCase
  class FindCertificate
    class QueryNotRegistered < RuntimeError; end
    class QueryNotValid < RuntimeError; end
    class AuthTokenMissing < RuntimeError; end

    def initialize(assessors_gateway)
      @certificates_gateway = assessors_gateway
    end

    def execute(query)
      gateway_response = @certificates_gateway.search(query)

      if gateway_response.include?(:errors)
        gateway_response[:errors].each do |error|
          raise QueryNotRegistered if error[:code] == 'NOT_FOUND'
          raise QueryNotValid if error[:code] == 'INVALID_REQUEST'
          raise AuthTokenMissing if error[:code] == 'Auth::Errors::TokenMissing'
        end
      end

      gateway_response[:results]
    end
  end
end
