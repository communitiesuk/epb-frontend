# frozen_string_literal: true

module FindCertificate
  class NoCertificatesStub
    def self.search_by_postcode(postcode = "BF1 3AA", type = "RdSAP")
      uri = "http://test-api.gov.uk/api/assessments/search?postcode=#{postcode}"

      assessment_types = type == "CEPC" ? %w[AC-CERT AC-REPORT CEPC CEPC-RR DEC DEC-RR] : %w[RdSAP SAP]

      uri += "&assessmentTypes=#{assessment_types.sort.join(',')}"

      WebMock
        .stub_request(:get, uri)
        .to_return(
          status: 200,
          body: {
            "data": {
              "assessments": [],
            },
            "meta": {
              "searchPostcode": postcode,
            },
          }.to_json,
        )
    end

    def self.search_by_id(reference_number)
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/assessments/search?assessment_id=#{
            reference_number
          }",
        )
        .to_return(
          status: 200,
          body: {
            "data": {
              "assessments": [],
            },
            "meta": {
              "searchReferenceNumber": reference_number,
            },
          }.to_json,
        )
    end

    def self.search_by_street_name_and_town(
      street_name,
      town,
      assessment_types = %w[RdSAP SAP]
    )
      route =
        "http://test-api.gov.uk/api/assessments/search?street=#{
          street_name
        }&town=#{town}"
      unless assessment_types.empty?
        route += "&assessmentTypes=#{assessment_types.sort.join(',')}"
      end

      WebMock
        .stub_request(:get, route)
        .to_return(
          status: 200,
          body: {
            "data": {
              "assessments": [],
            },
            "meta": {
              "searchReferenceNumber": [street_name, town],
            },
          }.to_json,
        )
    end
  end
end
