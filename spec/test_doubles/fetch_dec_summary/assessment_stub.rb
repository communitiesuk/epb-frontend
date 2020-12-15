# frozen_string_literal: true

module FetchDecSummary
  class AssessmentStub
    def self.fetch(assessment_id:)
      body = { data: "<xml></xml>" }

      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/dec_summary/#{assessment_id}",
        )
        .to_return(status: 200, body: body.to_json)
    end
  end
end
