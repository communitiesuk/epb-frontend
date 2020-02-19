# frozen_string_literal: true

class FindAssessorNoSchemeStub
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
            "code": 'SCHEME_NOT_FOUND',
            "message": 'There is no scheme for one of the requested assessor'
          }
        ]
      }.to_json
    )
  end
end
