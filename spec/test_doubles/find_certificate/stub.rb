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
            "User-Agent" => "Faraday v1.0.1",
          },
        )
        .to_return(
          status: 200,
          body: {
            "data": {
              "assessments": [
                {
                  assessmentId: "4567-6789-4567-6789-4567",
                  addressId: "RRN-1234-5678-9101-1122-1234",
                  dateOfAssessment: "2020-01-01",
                  dateRegistered: "2020-01-02",
                  dwellingType: "Top floor flat",
                  typeOfAssessment: type,
                  totalFloorArea: 50,
                  currentCarbonEmission: 2.4,
                  potentialCarbonEmission: 1.4,
                  currentEnergyEfficiencyRating: 90,
                  currentEnergyEfficiencyBand: "b",
                  potentialEnergyEfficiencyRating: "a",
                  potentialEnergyEfficiencyBand: 95,
                  postcode: "SW1B 2BB",
                  dateOfExpiry: "2019-01-01",
                  addressLine1: "2 Marsham Street",
                  town: "London",
                  heatDemand: {
                    currentSpaceHeatingDemand: 222,
                    currentWaterHeatingDemand: 321,
                    impactOfLoftInsulation: 79,
                    impactOfCavityInsulation: 67,
                    impactOfSolidWallInsulation: 69,
                  },
                  recommendedImprovements: [],
                  propertySummary: [],
                  greenDealPlan: {
                    "GreenDealPlanId": "ABC123456DEF",
                    "startDate": "2020-01-30",
                    "endDate": "2030-02-28",
                    "providerDetails": {
                      "name": "The Bank",
                      "telephone": "0800 0000000",
                      "email": "Lender@Example.com",
                    },
                    "interest": {
                      "rate": 12.3,
                      "fixed": true,
                    },
                    "chargeUplift": {
                      "amount": 1.25,
                      "date": "2025-03-29",
                    },
                    "ccaRegulated": true,
                    "structureChanged": false,
                    "measuresRemoved": false,
                    "measures": [
                      {
                        "sequence": 0,
                        "measureType": "Loft insulation",
                        "product": "WarmHome lagging stuff (TM)",
                        "repaidDate": "2025-03-29",
                      },
                    ],
                    "charges": [
                      {
                        "sequence": 0,
                        "startDate": "2020-03-29",
                        "endDate": "2030-03-29",
                        "dailyCharge": "0.34",
                      },
                    ],
                    "savings": [
                      {
                        "sequence": 0,
                        "fuelCode": "LPG",
                        "fuelSaving": 0,
                        "standingChargeFraction": -0.3,
                      },
                    ],
                  },
                },
                {
                  assessmentId: "1234-5678-9101-1122-1234",
                  addressId: "RRN-1234-5678-9101-1122-1234",
                  dateOfAssessment: "2020-01-01",
                  dateRegistered: "2020-01-02",
                  dwellingType: "Top floor flat",
                  typeOfAssessment: type,
                  totalFloorArea: 50,
                  currentEnergyEfficiencyRating: 90,
                  currentEnergyEfficiencyBand: "b",
                  potentialEnergyEfficiencyRating: "a",
                  potentialEnergyEfficiencyBand: 95,
                  postcode: "SW1B 2BB",
                  dateOfExpiry: "2030-01-01",
                  heatDemand: {
                    currentSpaceHeatingDemand: 222,
                    currentWaterHeatingDemand: 321,
                    impactOfLoftInsulation: 79,
                    impactOfCavityInsulation: 67,
                    impactOfSolidWallInsulation: 69,
                  },
                  recommendedImprovements: [{ sequence: 0 }, { sequence: 1 }],
                  propertySummary: [],
                },
                {
                  assessmentId: "1234-5678-9101-1123-1234",
                  addressId: "RRN-1234-5678-9101-1122-1235",
                  dateOfAssessment: "2020-01-01",
                  dateRegistered: "2020-01-02",
                  dwellingType: "Top floor flat",
                  typeOfAssessment: type,
                  totalFloorArea: 50,
                  currentEnergyEfficiencyRating: 90,
                  currentEnergyEfficiencyBand: "b",
                  postcode: "SW1B 2BB",
                  dateOfExpiry: "2032-01-01",
                },
                {
                  assessmentId: "9876-5678-9101-1123-9876",
                  addressId: "RRN-1234-5678-9101-1122-1235",
                  dateOfAssessment: "2020-01-02",
                  dateRegistered: "2020-01-02",
                  dwellingType: "Top floor flat",
                  typeOfAssessment: type,
                  totalFloorArea: 50,
                  currentEnergyEfficiencyRating: 20,
                  currentEnergyEfficiencyBand: "g",
                  postcode: "SW1B 2BB",
                  dateOfExpiry: "2032-01-01",
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
            "User-Agent" => "Faraday v1.0.1",
          },
        )
        .to_return(
          status: 200,
          body: {
            "data": {
              "assessments": [
                {
                  assessmentId: certificate_id,
                  dateOfAssessment: "2020-01-01",
                  dateRegistered: "2020-01-02",
                  dwellingType: "Top floor flat",
                  typeOfAssessment: type,
                  totalFloorArea: 50,
                  currentCarbonEmission: 4.4,
                  potentialCarbonEmission: 3.4,
                  currentEnergyEfficiencyRating: 90,
                  currentEnergyEfficiencyBand: "b",
                  potentialEnergyEfficiencyRating: "a",
                  potentialEnergyEfficiencyBand: 95,
                  dateOfExpiry: "2019-01-01",
                  addressLine1: "2 Marsham Street",
                  town: "London",
                  postcode: "SW1B 2BB",
                  heatDemand: {
                    currentSpaceHeatingDemand: 222,
                    currentWaterHeatingDemand: 321,
                    impactOfLoftInsulation: 79,
                    impactOfCavityInsulation: 67,
                    impactOfSolidWallInsulation: 69,
                  },
                },
              ],
            },
            "meta": {
              "searchReferenceNumber": certificate_id,
            },
          }.to_json,
        )
    end

    def self.search_by_street_name_and_town(
      street_name,
      town,
      assessment_types = %w[RdSAP SAP],
      returnedType = "RdSAP"
    )
      route =
        "http://test-api.gov.uk/api/assessments/search?street_name=#{
          street_name
        }&town=#{town}"
      assessment_types.each { |type| route += "&assessment_type[]=" + type }

      WebMock
        .stub_request(:get, route)
        .with(
          headers: {
            :Accept => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            :Authorization => "Bearer abc",
            "User-Agent" => "Faraday v1.0.1",
          },
        )
        .to_return(
          status: 200,
          body: {
            "data": {
              "assessments": [
                {
                  assessmentId: "1234-5678-9101-1121-3141",
                  dateOfAssessment: "2020-01-01",
                  dateRegistered: "2020-01-02",
                  dwellingType: "Top floor flat",
                  typeOfAssessment: returnedType,
                  totalFloorArea: 50,
                  currentCarbonEmission: 4.4,
                  potentialCarbonEmission: 3.4,
                  currentEnergyEfficiencyRating: 90,
                  currentEnergyEfficiencyBand: "b",
                  potentialEnergyEfficiencyRating: "a",
                  potentialEnergyEfficiencyBand: 95,
                  postcode: "SW1B 2BB",
                  dateOfExpiry: "2019-01-01",
                  addressLine1: street_name,
                  town: town,
                  heatDemand: {
                    currentSpaceHeatingDemand: 222,
                    currentWaterHeatingDemand: 321,
                    impactOfLoftInsulation: 79,
                    impactOfCavityInsulation: 67,
                    impactOfSolidWallInsulation: 69,
                  },
                },
                {
                  assessmentId: "1234-5678-9101-1122-1234",
                  dateOfAssessment: "2020-01-01",
                  dateRegistered: "2020-01-02",
                  dwellingType: "Top floor flat",
                  typeOfAssessment: returnedType,
                  totalFloorArea: 50,
                  currentCarbonEmission: 4.4,
                  potentialCarbonEmission: 3.4,
                  currentEnergyEfficiencyRating: 90,
                  currentEnergyEfficiencyBand: "b",
                  potentialEnergyEfficiencyRating: "a",
                  potentialEnergyEfficiencyBand: 95,
                  postcode: "SW1B 2BB",
                  dateOfExpiry: "2030-01-01",
                  addressLine1: street_name,
                  town: town,
                  heatDemand: {
                    currentSpaceHeatingDemand: 222,
                    currentWaterHeatingDemand: 321,
                    impactOfLoftInsulation: 79,
                    impactOfCavityInsulation: 67,
                    impactOfSolidWallInsulation: 69,
                  },
                },
                {
                  assessmentId: "1234-5678-9101-1123-1234",
                  dateOfAssessment: "2020-01-01",
                  dateRegistered: "2020-01-02",
                  dwellingType: "Top floor flat",
                  typeOfAssessment: returnedType,
                  totalFloorArea: 50,
                  currentCarbonEmission: 4.4,
                  potentialCarbonEmission: 3.4,
                  currentEnergyEfficiencyRating: 90,
                  currentEnergyEfficiencyBand: "b",
                  potentialEnergyEfficiencyRating: "a",
                  potentialEnergyEfficiencyBand: 95,
                  postcode: "SW1B 2BB",
                  dateOfExpiry: "2032-01-01",
                  addressLine1: street_name,
                  town: town,
                  heatDemand: {
                    currentSpaceHeatingDemand: 222,
                    currentWaterHeatingDemand: 321,
                    impactOfLoftInsulation: 79,
                    impactOfCavityInsulation: 67,
                    impactOfSolidWallInsulation: 69,
                  },
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
