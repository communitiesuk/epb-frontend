# frozen_string_literal: true

module UseCase
  class FindCertificateByStreetNameAndTown
    class StreetNameMissing < RuntimeError; end
    class TownMissing < RuntimeError; end
    class AuthTokenMissing < RuntimeError; end
    class CertificateNotFound < RuntimeError; end

    def initialize(assessors_gateway)
      @certificates_gateway = assessors_gateway
    end

    def execute(street_name, town)
      raise StreetNameMissing if street_name.nil? || street_name == ''
      raise TownMissing if town.nil? || town == ''

      gateway_response = @certificates_gateway.search_by_street_name_and_town(street_name, town)

      if gateway_response.include?(:errors)
        gateway_response[:errors].each do |error|
          raise AuthTokenMissing if error[:code] == 'Auth::Errors::TokenMissing'
        end
      end

      raise CertificateNotFound if gateway_response[:results].size == 0

      gateway_response[:results]
    end
  end
end
