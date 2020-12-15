# frozen_string_literal: true

module FetchDecSummary
  class AssessmentSummaryErrorStub
    def self.fetch(assessment_id:)
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/dec_summary/#{assessment_id}",
        )
        .to_return(
          status: 403,
          body: {
            "errors": [
              { "code": "NOT_A_DEC", "title": "Assessment is not a DEC" },
            ],
          }.to_json,
        )
    end
  end
end
