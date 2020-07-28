# frozen_string_literal: true

module FetchCertificate
  class RecommendationReportStub
    def self.fetch(
      assessment_id:,
      current_rating: 35,
      current_band: "b",
      potential_energy_efficiency_rating: 23,
      potential_energy_efficiency_band: "a",
      type_of_assessment: "CEPC-RR"
    )
      body = {
        data: {
          assessmentId: assessment_id,
          dateRegistered: "2020-01-05",
          dateOfExpiry: "2030-01-05",
          dateOfAssessment: "2020-01-02",
          typeOfAssessment: type_of_assessment,
          buildingEnvironment: "Heating and Natural Ventilation",
          totalUsefulFloorArea: 935.0,
          calculationTool: "CLG, iSBEM, v5.4.b, SBEM, v5.4.b.0",
          currentEnergyEfficiencyRating: current_rating,
          currentEnergyEfficiencyBand: current_band,
          potentialEnergyEfficiencyRating: potential_energy_efficiency_rating,
          potentialEnergyEfficiencyBand: potential_energy_efficiency_band,
          postcode: "SW1B 2BB",
          addressLine1: "Flat 33",
          addressLine2: "2 Marsham Street",
          addressLine3: "",
          addressLine4: "",
          town: "London",
          "assessor": {
            "firstName": "John",
            "lastName": "Howard",
            "middleNames": "T",
            "registeredBy": { "name": "ECMK", "schemeId": 2 },
            "schemeAssessorId": "ECMK201470",
            "searchResultsComparisonPostcode": "LU3 3UD",
            "address": {},
            "companyDetails": {
              "companyRegNo": "",
              "companyAddressLine1": "Lloyds House",
              "companyAddressLine2": "18 Lloyd Street",
              "companyAddressLine3": "",
              "companyTown": "Manchester",
              "companyPostcode": "M2 5WA",
              "companyWebsite": "",
              "companyTelephoneNumber": "",
              "companyEmail": "",
              "companyName": "Viridian Consulting Engineers Ltd",
            },
          },
          "nonDomCepcRr": {
            "longPaybackRecommendation": [
              {
                "recommendation":
                  "Consider installing an air source heat pump.",
                "carbon_impact": "HIGH",
              },
            ],
            "otherPaybackRecommendation": [
              {
                "recommendation": "Consider installing PV.",
                "carbon_impact": "HIGH",
              },
            ],
            "shortPaybackRecommendation": [
              {
                "recommendation":
                  "Consider replacing T8 lamps with retrofit T5 conversion kit.",
                "carbon_impact": "HIGH",
              },
              {
                "recommendation":
                  "Introduce HF (high frequency) ballasts for fluorescent tubes: Reduced number of fittings required.",
                "carbon_impact": "LOW",
              },
            ],
            "mediumPaybackRecommendation": [
              {
                "recommendation":
                  "Add optimum start/stop to the heating system.",
                "carbon_impact": "MEDIUM",
              },
            ],
          },
        },
      }

      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}",
      ).to_return(status: 200, body: body.to_json)
    end
  end
end
