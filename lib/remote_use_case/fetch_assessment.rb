# frozen_string_literal: true

module RemoteUseCase
  class FetchAssessment
    class AssessmentNotFound < RuntimeError; end

    def initialize(api_client)
      @internal_api_client = api_client
    end

    def execute(assessment_id)
      route =
        "/api/assessments/domestic-energy-performance/#{
          CGI.escape(assessment_id)
        }"

      response = @internal_api_client.get(route)
      if response.status == 404
        raise RemoteUseCase::FetchAssessment::AssessmentNotFound
      else
        assessment_details = JSON.parse(response.body, symbolize_names: true)

        result = {
          address_summary: assessment_details[:addressSummary],
          date_of_assessment:
            Date.parse(assessment_details[:dateOfAssessment]).strftime(
              '%d %B %Y'
            ),
          date_registered:
            Date.parse(assessment_details[:dateRegistered]).strftime(
              '%d %B %Y'
            ),
          assessment_id: assessment_details[:assessmentId],
          dwelling_type: assessment_details[:dwellingType],
          total_floor_area: assessment_details[:totalFloorArea],
          type_of_assessment: assessment_details[:typeOfAssessment],
          current_energy_efficiency_rating:
            assessment_details[:currentEnergyEfficiencyRating],
          current_energy_efficiency_band:
            assessment_details[:currentEnergyEfficiencyBand],
          potential_energy_efficiency_rating:
            assessment_details[:potentialEnergyEfficiencyRating],
          potential_energy_efficiency_band:
            assessment_details[:potentialEnergyEfficiencyBand]
        }

        raise AssessmentNotFound unless result

        result
      end
    end
  end
end
