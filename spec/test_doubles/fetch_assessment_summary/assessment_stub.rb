# frozen_string_literal: true

module FetchAssessmentSummary
  class AssessmentStub
    def self.fetch_cepc(
      assessment_id,
      energyEfficiencyBand,
      related_rrn = "4192-1535-8427-8844-6702"
    )
      body = {
        data: {
          assessmentId: assessment_id,
          dateOfExpiry: "2030-01-05",
          dateOfAssessment: "2020-01-04",
          dateOfRegistration: "2020-01-05",
          reportType: "3",
          typeOfAssessment: "CEPC",
          address: {
            addressLine1: "Flat 33",
            addressLine2: "2 Marsham Street",
            addressLine3: nil,
            addressLine4: nil,
            town: "London",
            postcode: "SW1B 2BB",
          },
          technicalInformation: {
            mainHeatingFuel: "Natural Gas",
            buildingEnvironment: "Air Conditioning",
            floorArea: "403",
            buildingLevel: "3",
          },
          buildingEmissionRate: "67.09",
          primaryEnergyUse: "413.22",
          relatedRrn: related_rrn,
          newBuildRating: "28",
          newBuildBand: "b",
          existingBuildRating: "81",
          existingBuildBand: "d",
          energyEfficiencyRating: "35",
          currentEnergyEfficiencyBand: energyEfficiencyBand,
          assessor: {
            name: "TEST NAME BOI",
            schemeAssessorId: "SPEC000000",
            contactDetails: {
              email: "test@testscheme.com", telephone: "012345"
            },
            companyDetails: {
              name: "Joe Bloggs Ltd",
              address: "Lloyds House, 18 Lloyd Street, Manchester, M2 5WA",
            },
            registeredBy: { name: "quidos", schemeId: "3" },
          },
          relatedPartyDisclosure: nil,
          propertyType: "B1 Offices and Workshop businesses",
        },
      }

      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end

    def self.fetch_cepc_rr(
      assessment_id = "0000-0000-0000-0000-0001",
      date_of_expiry = "2030-01-01",
      linked_to_cepc = "0000-0000-0000-0000-0000",
      related_party = nil,
      related_energy_band = "d"
    )
      body = {
        data: {
          typeOfAssessment: "CEPC-RR",
          assessmentId: assessment_id,
          reportType: "4",
          dateOfExpiry: date_of_expiry,
          dateOfRegistration: "2020-05-04",
          relatedCertificate: linked_to_cepc,
          relatedAssessments: [],
          address: {
            addressId: "UPRN-000000000000",
            addressLine1: "1 Lonely Street",
            addressLine2: nil,
            addressLine3: nil,
            addressLine4: nil,
            town: "Post-Town0",
            postcode: "A0 0AA",
          },
          assessor: {
            schemeAssessorId: "SPEC000000",
            name: "Mrs Report Writer",
            registeredBy: { name: "quidos", schemeId: 3 },
          },
          shortPaybackRecommendations: [
            {
              code: "1",
              text:
                "Consider replacing T8 lamps with retrofit T5 conversion kit.",
              cO2Impact: "HIGH",
            },
            {
              code: "3",
              text:
                "Introduce HF (high frequency) ballasts for fluorescent tubes: Reduced number of fittings required.",
              cO2Impact: "LOW",
            },
          ],
          mediumPaybackRecommendations: [
            {
              code: "2",
              text: "Add optimum start/stop to the heating system.",
              cO2Impact: "MEDIUM",
            },
          ],
          longPaybackRecommendations: [
            {
              code: "3",
              text: "Consider installing an air source heat pump.",
              cO2Impact: "HIGH",
            },
          ],
          otherRecommendations: [
            { code: "4", text: "Consider installing PV.", cO2Impact: "HIGH" },
          ],
          technicalInformation: {
            floorArea: "10",
            buildingEnvironment: "Natural Ventilation Only",
            calculationTool: "Calculation-Tool0",
          },
          relatedPartyDisclosure: related_party,
          energyBandFromRelatedCertificate: related_energy_band,
        },
      }
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end
  end
end
