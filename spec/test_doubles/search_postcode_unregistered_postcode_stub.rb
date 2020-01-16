class SearchPostcodeUnregisteredPostcodeStub
  def self.search
    WebMock.stub_request(:get, 'http://test-api.gov.uk/api/assessors/search/AF1+3AA')
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
