# frozen_string_literal: true

module UseCase
  class FindCertificateByReferenceNumber
    class ReferenceNumberNotValid < RuntimeError; end
    class AuthTokenMissing < RuntimeError; end
    class CertificateNotFound < RuntimeError; end

    def initialize(assessors_gateway)
      @certificates_gateway = assessors_gateway
    end

    def execute(query)
      raise ReferenceNumberNotValid if query == ''

      gateway_response = @certificates_gateway.search(query)

      if gateway_response.include?(:errors)
        gateway_response[:errors].each do |error|
          raise ReferenceNumberNotValid if error[:code] == 'INVALID_REQUEST'
          raise AuthTokenMissing if error[:code] == 'Auth::Errors::TokenMissing'
        end
      end

      raise CertificateNotFound if gateway_response[:results].size == 0

      gateway_response[:results]
    end
  end
end
