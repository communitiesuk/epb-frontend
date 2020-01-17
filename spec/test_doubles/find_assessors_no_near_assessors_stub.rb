# frozen_string_literal: true

class FindAssessorsNoNearAssessorsStub
  def self.search(postcode)
    WebMock.stub_request(
      :get,
      "http://test-api.gov.uk/api/assessors/search/#{postcode}"
    )
      .to_return(
      status: 200, body: { "results": [], "searchPostcode": 'BF1 3AA' }.to_json
    )
  end
end
