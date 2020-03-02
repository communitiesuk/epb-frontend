# frozen_string_literal: true

class FindCertificateNoNetworkStub
  def self.search_by_postcode(postcode)
    WebMock.stub_request(
      :get,
      "http://test-api.gov.uk/api/assessments/domestic-energy-performance/search/#{
      postcode
      }"
    )
      .to_raise(Auth::Errors::NetworkConnectionFailed)
  end

  def self.search_by_id(certificate_id)
    WebMock.stub_request(
      :get,
      "http://test-api.gov.uk/api/assessments/domestic-energy-performance/search/#{
      certificate_id
      }"
    )
      .to_raise(Auth::Errors::NetworkConnectionFailed)
  end
end
