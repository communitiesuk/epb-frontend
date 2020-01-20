# frozen_string_literal: true

class FetchAssessmentNoAssessmentStub
  def self.fetch
    WebMock.stub_request(
      :get,
      'http://test-api.gov.uk/api/assessments/domestic-energy-performance/123-456'
    )
      .to_return(status: 404, body: { error: 'not found' }.to_json)
  end
end
