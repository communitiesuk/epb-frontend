module CertificatesGateway
  class TooManyResultsStub
    def self.search_by_street_name_and_town(street_name, town, assessment_types:)
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/assessments/search?assessmentTypes=#{assessment_types.sort.join(',')}&street=#{CGI.escape(street_name)}&town=#{
          CGI.escape(town)}",
        )
        .to_return(
          status: 413,
          body: {
            "errors": [
              {
                "code": "PAYLOAD_TOO_LARGE",
                "message": "There are too many results",
              },
            ],
          }.to_json,
        )
    end
  end
end
