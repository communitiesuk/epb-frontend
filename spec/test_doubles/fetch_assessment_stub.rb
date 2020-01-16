# frozen_string_literal: true

class FetchAssessmentStub
  def self.fetch(assessment_id)
    WebMock.stub_request(
      :get,
      "http://test-api.gov.uk/api/assessments/domestic-energy-performance/#{
        assessment_id
      }"
    )
      .to_return(
      status: 200,
      body: {
        addressSummary: '2 Marsham Street, London, SW1B 2BB',
        assessmentId: '123-456'
      }.to_json
    )
  end
end
