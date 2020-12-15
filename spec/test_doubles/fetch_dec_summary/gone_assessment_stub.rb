# frozen_string_literal: true

module FetchDecSummary
  class GoneAssessmentStub
    def self.fetch(assessment_id:)
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/dec_summary/#{assessment_id}",
        )
        .to_return(
          status: 410,
          body: {
            "errors": [{ "code": "GONE", "title": "Assessment not for issue" }],
          }.to_json,
        )
    end
  end
end
