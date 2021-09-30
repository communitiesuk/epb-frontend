# frozen_string_literal: true

module FindAssessor
  module ByPostcode
    class NoNetworkStub
      def self.search_by_postcode(
        postcode,
        qualification_type = "domesticSap,domesticRdSap"
      )
        WebMock
          .stub_request(
            :get,
            "http://test-api.gov.uk/api/assessors?postcode=#{
              postcode
            }&qualification=#{qualification_type}",
          ).to_raise(Auth::Errors::NetworkConnectionFailed)
      end
    end
  end
end
