# frozen_string_literal: true

class FindCertificateNoCertificatesStub
  def self.search(postcode = 'BF1 3AA', reference_number = false)
    if postcode
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/domestic-energy-performance/search/#{
          postcode
        }"
      )
        .to_return(
        status: 200, body: { "results": [], "searchPostcode": postcode }.to_json
      )
    elsif reference_number
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/domestic-energy-performance/search/#{
          postcode
        }"
      )
        .to_return(
        status: 200,
        body: { "results": [], "searchReferenceNumber": postcode }.to_json
      )
    end
  end
end
