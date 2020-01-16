# frozen_string_literal: true

class FetchAssessmentStub
  def self.fetch
    WebMock.stub_request(
      :get,
      'http://test-api.gov.uk/api/assessments/domestic-energy-performance/122-456'
    )
      .to_return(status: 200, body: {}.to_json)
  end
end
