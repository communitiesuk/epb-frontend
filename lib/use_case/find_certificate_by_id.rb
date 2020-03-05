# frozen_string_literal: true

module UseCase
  class FindCertificateById < UseCase::Base
    def execute(reference_id)
      raise Errors::ReferenceNumberNotValid if reference_id == ''

      if reference_id.length == 20 && reference_id.scan(/\D/).empty?
        reference_id = reference_id.scan(/.{4}|.+/).join('-')
      end

      gateway_response = @gateway.search_by_id(reference_id)

      if gateway_response.include?(:errors)
        gateway_response[:errors].each do |error|
          if error[:code] == 'INVALID_REQUEST'
            raise Errors::ReferenceNumberNotValid
          end
          if error[:code] == 'Auth::Errors::TokenMissing'
            raise Errors::AuthTokenMissing
          end
        end
      end

      raise Errors::CertificateNotFound if gateway_response[:results].size == 0

      gateway_response[:results]
    end
  end
end
