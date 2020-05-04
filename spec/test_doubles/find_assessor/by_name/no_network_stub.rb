# frozen_string_literal: true

module FindAssessor
  module ByName
    class NoNetworkStub
      def self.search_by_name(name)
        WebMock.stub_request(
          :get,
          "http://test-api.gov.uk/api/assessors?name=#{name}",
        )
          .to_raise(Auth::Errors::NetworkConnectionFailed)
      end
    end
  end
end
