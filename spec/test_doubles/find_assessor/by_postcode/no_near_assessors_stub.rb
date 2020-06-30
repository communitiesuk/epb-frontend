# frozen_string_literal: true

module FindAssessor
  module ByPostcode
    class NoNearAssessorsStub
      def self.search_by_postcode(
        postcode, qualification_type = "domesticSap,domesticRdSap"
      )
        WebMock.stub_request(
          :get,
          "http://test-api.gov.uk/api/assessors?postcode=#{
            postcode
          }&qualification=#{qualification_type}",
        ).to_return(
          status: 200,
          body: {
            "data": { "assessors": [] }, "meta": { "searchPostcode": "BF1 3AA" }
          }.to_json,
        )
      end
    end
  end
end
