# frozen_string_literal: true

class FindAssessorUnregisteredPostcodeStub
  def self.search(postcode)
    WebMock.stub_request(
      :get,
      "http://test-api.gov.uk/api/assessors/search/#{postcode}"
    )
      .to_return(
      status: 200,
      body: {
        "errors": [
          {
            "code": 'NOT_FOUND',
            "message": 'The requested postcode is not registered'
          }
        ]
      }.to_json
    )
  end
end
