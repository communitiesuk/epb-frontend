# frozen_string_literal: true

module FindAssessor
  module ByPostcode
    class UnregisteredPostcodeStub
      def self.search_by_postcode(postcode)
        WebMock.stub_request(
          :get,
          "http://test-api.gov.uk/api/assessors?postcode=#{postcode}"
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
  end
end
