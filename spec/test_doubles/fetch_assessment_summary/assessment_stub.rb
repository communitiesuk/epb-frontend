# frozen_string_literal: true

module FetchAssessmentSummary
  class AssessmentStub
    def self.fetch(assessment_id, energyEfficiencyBand)
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
          relatedRrn: "4192-1535-8427-8844-6702",
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
        },
      }

      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end
  end
end
