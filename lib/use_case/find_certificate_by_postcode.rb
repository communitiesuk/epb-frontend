# frozen_string_literal: true

module UseCase
  class FindCertificateByPostcode < UseCase::Base
    def execute(query, types = %w[RdSAP SAP])
      unless Regexp.new(
        '^[A-Z]{1,2}\d[A-Z\d]?\s?\d[A-Z]{2}$',
        Regexp::IGNORECASE,
      ).match(query)
        raise Errors::PostcodeNotValid
      end

      gateway_response = @gateway.search_by_postcode(query, types)

      raise_errors_if_exists(gateway_response)

      {
        data: {
          assessments:
            FilterLatestCertificates.new(@gateway).execute(gateway_response),
        },
      }
    end
  end
end
