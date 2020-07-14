# frozen_string_literal: true

module FindCertificate
  class NoCertificatesStub
    def self.search_by_postcode(postcode = "BF1 3AA")
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/search?postcode=#{
          postcode
        }&assessment_type[]=SAP&assessment_type[]=RdSAP",
      ).to_return(
        status: 200,
        body: {
          "data": { "assessments": [] }, "meta": { "searchPostcode": postcode }
        }.to_json,
      )
    end

    def self.search_by_id(reference_number)
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/search?assessment_id=#{
          reference_number
        }",
      ).to_return(
        status: 200,
        body: {
          "data": { "assessments": [] },
          "meta": { "searchReferenceNumber": reference_number },
        }.to_json,
      )
    end

    def self.search_by_street_name_and_town(street_name, town)
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/search?street_name=#{
          street_name
        }&town=#{town}",
      ).to_return(
        status: 200,
        body: {
          "data": { "assessments": [] },
          "meta": { "searchReferenceNumber": [street_name, town] },
        }.to_json,
      )
    end
  end
end
