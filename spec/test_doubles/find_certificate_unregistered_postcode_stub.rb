# frozen_string_literal: true

class FindCertificateUnregisteredPostcodeStub
  def self.search(postcode)
    WebMock.stub_request(
      :get,
      "http://test-api.gov.uk/api/assessments/domestic-energy-performance/search/#{postcode}"
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
