# frozen_string_literal: true

module FindAssessor
  module ByPostcode
    class NoAssessorsStub
      def self.search_by_postcode
        WebMock.stub_request(
          :get,
          "http://test-api.gov.uk/api/assessors?postcode=BF1+3AA&qualification=domesticSap,domesticRdSap",
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
