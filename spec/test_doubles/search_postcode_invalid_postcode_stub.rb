class SearchPostcodeInvalidPostcodeStub
  def self.search
    WebMock.stub_request(:get, 'http://test-api.gov.uk/api/assessors/search/1+3AA')
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
