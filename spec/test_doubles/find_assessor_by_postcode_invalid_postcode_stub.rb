# frozen_string_literal: true

class FindAssessorByPostcodeInvalidPostcodeStub
  def self.search(postcode)
    WebMock.stub_request(
      :get,
      "http://test-api.gov.uk/api/assessors?postcode=#{postcode}"
    )
      .to_return(
      status: 200,
      body: {
        "errors": [
          {
            "code": 'INVALID_REQUEST',
            "title": 'The requested postcode is not valid'
          }
        ]
      }.to_json
    )
  end
end
