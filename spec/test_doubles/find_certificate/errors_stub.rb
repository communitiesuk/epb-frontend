module FindCertificate
  class ErrorsStub
    def self.search_by_invalid_id(certificate_id)
      uri = "http://test-api.gov.uk/api/assessments/search?assessmentId=#{certificate_id}"

      WebMock
        .stub_request(:get, uri)
        .to_return(
          status: 400,
          body: {
            "errors": [
              {
                "code": "INVALID_REQUEST",
                "message": "The requested assessment id is not valid",
              },
            ],
          }.to_json,
        )
    end
  end
end
