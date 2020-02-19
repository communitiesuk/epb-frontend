# frozen_string_literal: true

class FindAssessorByNameNoAssessorsStub
  def self.search(name)
    WebMock.stub_request(
      :get,
      'http://test-api.gov.uk/api/assessors?name=' + name
    )
      .to_return(
      status: 200, body: { "results": [], "searchName": name }.to_json
    )
  end
end
