# frozen_string_literal: true

module FindCertificate
  class Stub
    def self.search_by_postcode(postcode, type = "RdSAP")
      uri = "http://test-api.gov.uk/api/assessments/search?postcode=#{postcode}"

      uri +=
        if type == "CEPC"
          "&assessment_type[]=AC-CERT&assessment_type[]=AC-REPORT&assessment_type[]=CEPC&assessment_type[]=DEC&assessment_type[]=DEC-RR&assessment_type[]=CEPC-RR"
        else
          "&assessment_type[]=SAP&assessment_type[]=RdSAP"
        end

      WebMock
        .stub_request(:get, uri)
        .with(
          headers: {
            :Accept => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            :Authorization => "Bearer abc",
          },
        )
        .to_return(
          status: 200,
          body: {
            "data": {
              "assessments": [
                {
                  dateOfAssessment: "2020-01-01",
                  dateOfRegistration: "2020-01-02",
                  dateOfExpiry: "2019-01-01",
                  typeOfAssessment: type,
                  assessmentId: "4567-6789-4567-6789-4567",
                  currentEnergyEfficiencyRating: 90,
                  currentEnergyEfficiencyBand: "b",
                  optOut: false,
                  addressId: "RRN-1234-5678-9101-1122-1234",
                  addressLine1: "",
                  addressLine2: "",
                  addressLine3: "",
                  addressLine4: "2 Marsham Street",
                  town: "London",
                  postcode:,
                  status: "ENTERED",
                },
                {
                  dateOfAssessment: "2020-01-01",
                  dateOfRegistration: "2020-01-03",
                  dateOfExpiry: "2030-01-01",
                  typeOfAssessment: type,
                  assessmentId: type != "CEPC" ? "1234-5678-9101-1122-1234" : "1234-5678-9101-1122-5678",
                  currentEnergyEfficiencyRating: 90,
                  currentEnergyEfficiencyBand: "b",
                  optOut: false,
                  addressId: "RRN-1234-5678-9101-1122-1234",
                  addressLine1: "  ",
                  addressLine2: "2 Marsham Street",
                  addressLine3: "  \n\n",
                  addressLine4: "",
                  town: "London",
                  postcode:,
                  status: "ENTERED",
                },
                {
                  dateOfAssessment: "2020-01-01",
                  dateOfRegistration: "2020-01-05",
                  dateOfExpiry: "2032-01-01",
                  typeOfAssessment: type,
                  assessmentId: "1234-5678-9101-1123-1234",
                  currentEnergyEfficiencyRating: 90,
                  currentEnergyEfficiencyBand: "b",
                  optOut: false,
                  addressId: "RRN-1234-5678-9101-1122-1235",
                  addressLine1: "",
                  addressLine2: "",
                  addressLine3: "2 Marsham Street   \n\n",
                  addressLine4: " ",
                  town: "London",
                  postcode:,
                  status: "ENTERED",
                },
                {
                  dateOfAssessment: "2020-01-02",
                  dateOfRegistration: "2020-01-04",
                  dateOfExpiry: "2032-01-01",
                  typeOfAssessment: type,
                  assessmentId: "9876-5678-9101-1123-9876",
                  currentEnergyEfficiencyRating: 20,
                  currentEnergyEfficiencyBand: "g",
                  optOut: false,
                  addressId: "RRN-1234-5678-9101-1122-1235",
                  addressLine1: "",
                  addressLine2: "",
                  addressLine3: "",
                  addressLine4: "2 Marsham Street",
                  town: "London",
                  postcode: "SW1B 2BB",
                  status: "ENTERED",
                },
              ],
            },
            "meta": {
              "searchPostcode": postcode,
            },
          }.to_json,
        )
    end

    def self.search_by_id(certificate_id, type = "RdSAP")
      WebMock
        .stub_request(
          :get,
          "http://test-api.gov.uk/api/assessments/search?assessment_id=#{
            certificate_id
          }",
        )
        .with(
          headers: {
            :Accept => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            :Authorization => "Bearer abc",
          },
        )
        .to_return(
          status: 200,
          body: {
            "data": {
              "assessments": [
                {
                  dateOfAssessment: "2020-01-01",
                  dateOfRegistration: "2020-01-02",
                  dateOfExpiry: "2029-01-01",
                  typeOfAssessment: type,
                  assessmentId: certificate_id,
                  currentEnergyEfficiencyRating: 90,
                  currentEnergyEfficiencyBand: "b",
                  optOut: false,
                  "addressId": "UPRN-100021846790",
                  "addressLine1": "2 Marsham Street",
                  "addressLine2": "",
                  "addressLine3": "",
                  "addressLine4": "",
                  town: "London",
                  postcode: "SW1B 2BB",
                  "status": "ENTERED",
                },
              ],
            },
            "meta": {
              "searchQuery": certificate_id,
            },
          }.to_json,
        )
    end

    def self.search_by_street_name_and_town(
      street_name,
      town,
      assessment_types = %w[RdSAP SAP],
      returned_type = "RdSAP"
    )
      route =
        "http://test-api.gov.uk/api/assessments/search?street_name=#{
          street_name
        }&town=#{town}"
      assessment_types.each { |type| route += "&assessment_type[]=#{type}" }

      WebMock
        .stub_request(:get, route)
        .with(
          headers: {
            :Accept => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            :Authorization => "Bearer abc",
          },
        )
        .to_return(
          status: 200,
          body: {
            "data": {
              "assessments": [
                {
                  dateOfAssessment: "2020-01-01",
                  dateOfRegistration: "2020-01-02",
                  dateOfExpiry: "2019-01-01",
                  typeOfAssessment: returned_type,
                  assessmentId: "1234-5678-9101-1121-3141",
                  currentEnergyEfficiencyRating: 90,
                  currentEnergyEfficiencyBand: "b",
                  optOut: false,
                  addressId: "RRN-1234-5678-9101-1122-1234",
                  addressLine1: street_name,
                  addressLine2: "",
                  addressLine3: "",
                  addressLine4: "",
                  town:,
                  postcode: "SW1B 2BB",
                  status: "ENTERED",
                  createdAt: nil,
                },
                {
                  dateOfAssessment: "2020-01-01",
                  dateOfRegistration: "2020-01-02",
                  dateOfExpiry: "2030-01-01",
                  typeOfAssessment: returned_type,
                  assessmentId: "1234-5678-9101-1122-1234",
                  currentEnergyEfficiencyRating: 90,
                  currentEnergyEfficiencyBand: "b",
                  optOut: false,
                  addressId: "RRN-1234-5678-9101-1122-1234",
                  addressLine1: street_name,
                  addressLine2: "",
                  addressLine3: "",
                  addressLine4: "",
                  town:,
                  postcode: "SW1B 2BB",
                  status: "ENTERED",
                  createdAt: nil,
                },
                {
                  dateOfAssessment: "2020-01-01",
                  dateOfRegistration: "2020-01-03",
                  dateOfExpiry: "2032-01-01",
                  typeOfAssessment: returned_type,
                  assessmentId: "1234-5678-9101-1123-1234",
                  currentEnergyEfficiencyRating: 90,
                  currentEnergyEfficiencyBand: "b",
                  optOut: false,
                  addressId: "RRN-1234-5678-9101-1122-1234",
                  addressLine1: street_name,
                  addressLine2: "",
                  addressLine3: "",
                  addressLine4: "",
                  town:,
                  postcode: "SW1B 2BB",
                  status: "ENTERED",
                  createdAt: nil,
                },
              ],
            },
            "meta": {
              "searchReferenceNumber": [street_name, town],
            },
          }.to_json,
        )
    end
  end
end
