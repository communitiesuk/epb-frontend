# frozen_string_literal: true

class FindAssessorNoNetworkStub
  def self.search(postcode)
    WebMock.stub_request(
      :get,
      "http://test-api.gov.uk/api/assessors?postcode=#{postcode}"
    )
      .to_raise(Auth::Errors::NetworkConnectionFailed)
  end
end
