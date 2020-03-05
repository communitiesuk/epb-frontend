# frozen_string_literal: true

module UseCase
  class FindCertificateByPostcode < UseCase::Base
    def execute(query)
      unless Regexp.new(
               '^[A-Z]{1,2}\d[A-Z\d]?\s?\d[A-Z]{2}$',
               Regexp::IGNORECASE
             )
               .match(query)
        raise Errors::PostcodeNotValid
      end

      gateway_response = @gateway.search_by_postcode(query)

      if gateway_response.include?(:errors)
        gateway_response[:errors].each do |error|
          if error[:code] == 'Auth::Errors::TokenMissing'
            raise Errors::AuthTokenMissing
          end
        end
      end

      gateway_response[:results]
    end
  end
end
