# frozen_string_literal: true

module UseCase
  class FindCertificateByReferenceNumber
    class ReferenceNumberNotValid < RuntimeError; end
    class AuthTokenMissing < RuntimeError; end
    class CertificateNotFound < RuntimeError; end

    def initialize(assessors_gateway)
      @certificates_gateway = assessors_gateway
    end

    def execute(reference_id)
      raise ReferenceNumberNotValid if reference_id == ''

      if reference_id.length == 20 && reference_id.scan(/\D/).empty?
        reference_id = reference_id.scan(/.{4}|.+/).join('-')
      end

      gateway_response = @certificates_gateway.search(reference_id)

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
