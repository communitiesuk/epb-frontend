# frozen_string_literal: true

class FindAssessorByNameTooManyResultsStub
  def self.search_by_name(name)
    WebMock.stub_request(
      :get,
      "http://test-api.gov.uk/api/assessors?name=#{name}"
    )
      .to_return(
      status: 200,
      body: {
        "errors": [{ "code": 'TOO_MANY_RESULTS', "title": 'Too many results' }]
      }.to_json
    )
  end
end
