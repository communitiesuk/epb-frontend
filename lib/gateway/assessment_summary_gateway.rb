# frozen_string_literal: true

module Gateway
  class AssessmentSummaryGateway
    class AssessmentNotFound < StandardError
    end
    def fetch(assessment_id)
      route = "/api/assessments/#{CGI.escape(assessment_id)}/summary"
      response = Container.new.get_object(:internal_api_client).get(route)

      assessment_summary = JSON.parse(response.body, symbolize_names: true)

      if response.status == 200
        unless assessment_summary.dig(:data, :dateOfExpiry).nil?
          assessment_summary[:data][:dateOfExpiry] =
            Date.parse(assessment_summary[:data][:dateOfExpiry])
        end

        unless assessment_summary.dig(:data, :dateOfAssessment).nil?
          assessment_summary[:data][:dateOfAssessment] =
            Date.parse(assessment_summary[:data][:dateOfAssessment])
        end

        unless assessment_summary.dig(:data, :dateRegistered).nil?
          assessment_summary[:data][:dateRegistered] =
            Date.parse(assessment_summary[:data][:dateRegistered])
        end
      end

      assessment_summary
    end
  end
end
