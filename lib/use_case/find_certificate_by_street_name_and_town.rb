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
          street_name.strip,
          town.strip,
          assessment_types,
        )

      raise_errors_if_exists(gateway_response) { |error| }

      if gateway_response[:data][:assessments].empty?
        raise Errors::CertificateNotFound
      end

      {
        data: {
          assessments:
            FilterLatestCertificates.new(@gateway).execute(gateway_response),
        },
      }
    end

  private

    def truly_empty(query)
      query.nil? || query.strip.empty?
    end
  end
end
