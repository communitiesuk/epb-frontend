class SearchPostcodeNoSchemeStub
  def self.search
    WebMock.stub_request(:get, 'http://test-api.gov.uk/api/assessors/search/1+3AA')
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
