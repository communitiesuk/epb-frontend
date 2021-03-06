# frozen_string_literal: true

module FetchAssessmentSummary
  class NoAssessmentStub
    def self.fetch(assessment_id)
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
        )
        .to_return(
          status: 404,
          body: {
            "errors": [{ "code": "NOT_FOUND", "title": "Assessment not found" }],
          }.to_json,
        )
    end

    def self.fetch_invalid_assessment_id(assessment_id)
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
        )
        .to_return(
          status: 404,
          body: {
            "errors": [
              { "code": "INVALID_QUERY", "title": "Assessment ID not valid" },
            ],
          }.to_json,
        )
    end
  end
end
