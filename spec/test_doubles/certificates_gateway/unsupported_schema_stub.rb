# frozen_string_literal: true

module CertificatesGateway
  class UnsupportedSchemaStub
    def self.fetch_dec_summary(assessment_id)
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/dec_summary/#{assessment_id}",
        )
        .to_return(
          status: 400,
          body: {
            "errors": [
              {
                "code": "INVALID_REQUEST",
                "message": "Unsupported schema type",
              },
            ],
          }.to_json,
        )
    end
  end
end
