# frozen_string_literal: true

module FetchDecSummary
  class AssessmentNotSupportedStub
    def self.fetch(assessment_id:)
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/dec_summary/#{assessment_id}",
        )
        .to_return(
          status: 404,
          body: {
            "errors": [
              { "code": "NOT_FOUND", "title": "Assessment not supported" },
            ],
          }.to_json,
        )
    end
  end
end
