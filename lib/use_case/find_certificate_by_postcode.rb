# frozen_string_literal: true

module UseCase
  class FindCertificateByPostcode < UseCase::Base
    def execute(query, types = %w[RdSAP SAP])
      Helper::PostcodeValidator.validate(query)

      gateway_response = @gateway.search_by_postcode(query, types)

      raise_errors_if_exists(gateway_response) do |error|
        if error[:title] == "The requested postcode is not valid"
          raise Errors::PostcodeNotValid
        end
      end

      {
        data: {
          assessments:
            FilterLatestCertificates.new(@gateway).execute(gateway_response),
        },
      }
    end
  end
end
