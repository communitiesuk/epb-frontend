# frozen_string_literal: true

module Gateway
  class EnergyAssessmentsGateway
    def initialize(api_client)
      @internal_api_client = api_client
    end

    def fetch_assessment(assessment_id)
      route =
        URI.encode(
          "/api/assessments/domestic-energy-performance/#{assessment_id}"
        )
      response = @internal_api_client.get(route)
      if response.status == 404
        nil
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
          type_of_assessment: assessment_details[:typeOfAssessment]
        }

        result
      end
    end
  end
end
