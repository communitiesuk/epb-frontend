# frozen_string_literal: true

module UseCase
  class FindCertificateById < UseCase::Base
    def execute(reference_id)
      raise Errors::ReferenceNumberNotValid if reference_id == ''

      if reference_id.length == 20 && reference_id.scan(/\D/).empty?
        reference_id = reference_id.scan(/.{4}|.+/).join('-')
      end

      gateway_response = @gateway.search_by_id(reference_id)

      raise_errors_if_exists(gateway_response) do |error_code|
        raise Errors::ReferenceNumberNotValid if error_code == 'INVALID_REQUEST'
      end

      raise Errors::CertificateNotFound if gateway_response[:results].size == 0

      gateway_response[:results]
    end
  end
end
