# frozen_string_literal: true

class FindCertificateNoNetworkStub
  def self.search(postcode)
    WebMock.stub_request(
      :get,
      "http://test-api.gov.uk/api/assessments/domestic-energy-performance/search/#{postcode}"
    )
      .to_raise(Auth::Errors::NetworkConnectionFailed)
  end
end
