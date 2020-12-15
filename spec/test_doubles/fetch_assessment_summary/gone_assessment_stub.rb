# frozen_string_literal: true

module FetchAssessmentSummary
  class GoneAssessmentStub
    def self.fetch(assessment_id)
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
        )
        .to_return(
          status: 410,
          body: {
            "errors": [
              { "code": "GONE", "title": "Assessment marked not for issue" },
            ],
          }.to_json,
        )
    end
  end
end
