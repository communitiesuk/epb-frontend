# frozen_string_literal: true

class FindAssessorNoAssessorsStub
  def self.search
    WebMock.stub_request(
      :get,
      'http://test-api.gov.uk/api/assessors/search/BF1+3AA'
    )
      .to_return(
      status: 200, body: { "results": [], "searchPostcode": 'BF1 3AA' }.to_json
    )
  end
end
