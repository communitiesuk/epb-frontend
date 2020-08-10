# frozen_string_literal: true

module UseCase
  class FindCertificateByStreetNameAndTown < UseCase::Base
    def execute(street_name, town, assessment_types)
      if truly_empty(street_name) && truly_empty(town)
        raise Errors::AllParamsMissing
      end
      raise Errors::StreetNameMissing if truly_empty(street_name)
      raise Errors::TownMissing if truly_empty(town)

      gateway_response =
        @gateway.search_by_street_name_and_town(
          street_name,
          town,
          assessment_types,
        )

      raise_errors_if_exists(gateway_response)

      if gateway_response[:data][:assessments].empty?
        raise Errors::CertificateNotFound
      end

      modified_response = {}

      gateway_response[:data][:assessments].each do |certificate|
        address_id =
          if certificate[:addressId].nil?
            ("RRN-" + certificate[:assessmentId]).to_sym
          else
            certificate[:addressId].to_sym
          end

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

  private

    def truly_empty(query)
      query.nil? || query.strip.empty?
    end
  end
end
