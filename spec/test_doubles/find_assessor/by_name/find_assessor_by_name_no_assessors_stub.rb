# frozen_string_literal: true

class FindAssessorByNameNoAssessorsStub
  def self.search_by_name(name)
    WebMock.stub_request(
      :get,
      'http://test-api.gov.uk/api/assessors?name=' + name
    )
      .to_return(
      status: 200,
      body: { "results": [], "searchName": name, "looseMatch": false }.to_json
    )
  end
end
