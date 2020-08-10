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

      modified_response = {}

      gateway_response[:data][:assessments].each do |certificate|
        address_id =
          if certificate[:addressId].nil?
            "RRN-" + certificate[:assessmentId]
          else
            certificate[:addressId]
          end.to_sym

        unless modified_response.key?(address_id)
          modified_response[address_id] = {
            addressLine1: certificate[:addressLine1],
            addressLine2: certificate[:addressLine2],
            addressLine3: certificate[:addressLine3],
            addressLine4: certificate[:addressLine4],
            postcode: certificate[:postcode],
            town: certificate[:town],
            certificates: [],
          }
        end

        modified_response[address_id][:certificates].push(certificate)
      end

      { data: { assessments: modified_response } }
    end
  end
end
