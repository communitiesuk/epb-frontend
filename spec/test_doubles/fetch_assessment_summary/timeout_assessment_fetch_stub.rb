module FetchAssessmentSummary
  class TimeoutAssessmentFetchStub
    def self.fetch(assessment_id:)
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
        )
        .to_raise Faraday::TimeoutError
    end
  end
end
