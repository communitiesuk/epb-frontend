# frozen_string_literal: true

module Gateway
  class AssessmentSummaryGateway
    class AssessmentNotFound < StandardError; end
    def fetch(assessment_id)
      route = "/api/assessments/#{CGI.escape(assessment_id)}/summary"
      response = Container.new.get_object(:internal_api_client).get(route)

      assessment_details = JSON.parse(response.body, symbolize_names: true)

      if response.status == 404
        raise Errors::AssessmentNotFound
      end

      response.status == 200 ?
          assessment_details : nil
    end
  end
end
