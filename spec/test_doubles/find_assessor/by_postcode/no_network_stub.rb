# frozen_string_literal: true

module FindAssessor
  module ByPostcode
    class NoNetworkStub
      def self.search_by_postcode(postcode)
        WebMock.stub_request(
          :get,
          "http://test-api.gov.uk/api/assessors?postcode=#{postcode}"
        )
          .to_raise(Auth::Errors::NetworkConnectionFailed)
      end
    end
  end
end
