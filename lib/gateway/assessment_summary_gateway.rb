# frozen_string_literal: true

module Gateway
  class AssessmentSummaryGateway
    class AssessmentNotFound < StandardError; end
    def fetch(assessment_id)
      route = "/api/assessments/#{CGI.escape(assessment_id)}/summary"
      response = Container.new.get_object(:internal_api_client).get(route)

      assessment_details = JSON.parse(response.body, symbolize_names: true)

      raise Errors::AssessmentNotFound if response.status == 404

      response.status == 200 ? assessment_details : nil
    end
  end
end
