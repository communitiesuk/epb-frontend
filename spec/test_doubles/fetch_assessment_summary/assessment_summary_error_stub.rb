# frozen_string_literal: true

module FetchAssessmentSummary
  class AssessmentSummaryErrorStub
    def self.fetch(assessment_id)
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(
        status: 500,
        body: {
          "errors": [
            { "code": "UNSUPPORTED_TYPE", "title": "Assessment not found" },
          ],
        }.to_json,
      )
    end
  end
end
