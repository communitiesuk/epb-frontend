# frozen_string_literal: true

module FetchCertificate
  class NoAssessmentStub
    def self.fetch(assessment_id)
      FetchAssessmentSummary::AssessmentSummaryErrorStub.fetch(assessment_id)
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}",
      ).to_return(
        status: 404,
        body: {
          "errors": [{ "code": "NOT_FOUND", "title": "Assessment not found" }],
        }.to_json,
      )
    end
  end
end
