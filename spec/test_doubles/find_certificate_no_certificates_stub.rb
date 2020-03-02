# frozen_string_literal: true

class FindCertificateNoCertificatesStub
  def self.search_by_postcode(postcode = 'BF1 3AA')
    WebMock.stub_request(
      :get,
      "http://test-api.gov.uk/api/assessments/domestic-energy-performance/search?postcode=#{
      postcode
      }"
    )
      .to_return(
        status: 200, body: { "results": [], "searchPostcode": postcode }.to_json
      )
  end

  def self.search_by_id(reference_number = false)
    WebMock.stub_request(
      :get,
      "http://test-api.gov.uk/api/assessments/domestic-energy-performance/search?assessment_id=#{
      reference_number
      }"
    )
      .to_return(
        status: 200,
        body: { "results": [], "searchReferenceNumber": reference_number }.to_json
      )
  end
end
