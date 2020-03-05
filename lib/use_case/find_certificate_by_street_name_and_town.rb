# frozen_string_literal: true

module UseCase
  class FindCertificateByStreetNameAndTown < UseCase::Base
    class AllParamsMissing < RuntimeError; end
    class StreetNameMissing < RuntimeError; end
    class TownMissing < RuntimeError; end
    class AuthTokenMissing < RuntimeError; end
    class CertificateNotFound < RuntimeError; end

    def execute(street_name, town)
      raise AllParamsMissing if truly_empty(street_name) && truly_empty(town)
      raise StreetNameMissing if truly_empty(street_name)
      raise TownMissing if truly_empty(town)

      gateway_response =
        @gateway.search_by_street_name_and_town(street_name, town)

      if gateway_response.include?(:errors)
        gateway_response[:errors].each do |error|
          raise AuthTokenMissing if error[:code] == 'Auth::Errors::TokenMissing'
        end
      end

      raise CertificateNotFound if gateway_response[:results].size == 0

      gateway_response[:results]
    end

    private

    def truly_empty(query)
      query.nil? || query == ''
    end
  end
end
