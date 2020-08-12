# frozen_string_literal: true

module FetchAssessmentSummary
  class AssessmentStub
    def self.fetch_cepc(
      assessment_id,
      energyEfficiencyBand,
      related_rrn = "4192-1535-8427-8844-6702",
      related_assessments = true,
      related_party_disclosure = nil
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
          relatedPartyDisclosure: related_party_disclosure,
          propertyType: "B1 Offices and Workshop businesses",
          relatedAssessments:
            if related_assessments
              [
                {
                  assessmentExpiryDate: "2026-05-04",
                  assessmentId: "0000-0000-0000-0000-0001",
                  assessmentStatus: "ENTERED",
                  assessmentType: "CEPC",
                },
                {
                  assessmentExpiryDate: "2002-07-01",
                  assessmentId: "0000-0000-0000-0000-0002",
                  assessmentStatus: "EXPIRED",
                  assessmentType: "CEPC-RR",
                },
              ]
            end,
        },
      }

      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end

    def self.fetch_cepc_rr(
      assessment_id: "0000-0000-0000-0000-0001",
      date_of_expiry: "2030-01-01",
      linked_to_cepc: "0000-0000-0000-0000-0000",
      related_party: nil,
      related_energy_band: "d",
      related_assessments: [
        {
          assessmentId: "0000-0000-0000-0000-5555",
          assessmentStatus: "ENTERED",
          assessmentType: "RdSAP",
          assessmentExpiryDate: "2030-05-04",
        },
        {
          assessmentId: "9457-0000-0000-0000-2000",
          assessmentStatus: "ENTERED",
          assessmentType: "CEPC-RR",
          assessmentExpiryDate: "2026-05-04",
        },
      ],
      company_details: {
        name: "Joe Bloggs Ltd", address: "123 My Street, My City, AB3 4CD"
      }
    )
      body = {
        data: {
          typeOfAssessment: "CEPC-RR",
          assessmentId: assessment_id,
          reportType: "4",
          dateOfExpiry: date_of_expiry,
          dateOfRegistration: "2020-05-04",
          relatedCertificate: linked_to_cepc,
          relatedAssessments: related_assessments,
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
            companyDetails: company_details,
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

    def self.fetch_dec(
      assessment_id = "0000-0000-0000-0000-0001",
      date_of_expiry = "2030-01-01",
      related_assessments = true
    )
      body = {
        data: {
          typeOfAssessment: "DEC",
          assessmentId: assessment_id,
          reportType: "1",
          dateOfExpiry: date_of_expiry,
          address: {
            addressId: "UPRN-000000000001",
            addressLine1: "2 Lonely Street",
            addressLine2: nil,
            addressLine3: nil,
            addressLine4: nil,
            town: "Post-Town1",
            postcode: "A0 0AA",
          },
          currentAssessment: {
            date: "2020-01-01",
            energyEfficiencyRating: "1",
            energyEfficiencyBand: "a",
            heatingCo2: "3",
            electricityCo2: "7",
            renewablesCo2: "0",
          },
          year1Assessment: {
            date: "2019-01-01",
            energyEfficiencyRating: "24",
            energyEfficiencyBand: "a",
            heatingCo2: "5",
            electricityCo2: "10",
            renewablesCo2: "1",
          },
          year2Assessment: {
            date: "2018-01-01",
            energyEfficiencyRating: "40",
            energyEfficiencyBand: "b",
            heatingCo2: "10",
            electricityCo2: "15",
            renewablesCo2: "2",
          },
          technicalInformation: {
            mainHeatingFuel: "Natural Gas",
            buildingEnvironment: "Heating and Natural Ventilation",
            floorArea: "99",
            assetRating: "1",
            annualEnergyUseFuelThermal: "11",
            annualEnergyUseElectrical: "12",
            typicalThermalUse: "13",
            typicalElectricalUse: "14",
            renewablesFuelThermal: "15",
            renewablesElectrical: "16",
          },
          administrativeInformation: {
            calculationTool: "DCLG, ORCalc, v3.6.3",
          },
          assessor: {
            name: "TEST NAME BOI",
            schemeAssessorId: "SPEC000000",
            registeredBy: { name: "test scheme", schemeId: 1 },
            companyDetails: {
              address: "123 My Street, My City, AB3 4CD", name: "Joe Bloggs Ltd"
            },
          },
          relatedAssessments:
            if related_assessments
              [
                {
                  assessmentExpiryDate: "2026-05-04",
                  assessmentId: "0000-0000-0000-0000-0001",
                  assessmentStatus: "ENTERED",
                  assessmentType: "CEPC",
                },
                {
                  assessmentExpiryDate: "2002-07-01",
                  assessmentId: "0000-0000-0000-0000-0002",
                  assessmentStatus: "EXPIRED",
                  assessmentType: "CEPC-RR",
                },
              ]
            end,
        },
      }
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end

    def self.fetch_dec_rr(
      assessment_id: "0000-0000-0000-0000-0001", date_of_expiry: "2030-01-01"
    )
      body = {
        data: {
          typeOfAssessment: "DEC-RR",
          assessmentId: assessment_id,
          reportType: "2",
          dateOfExpiry: date_of_expiry,
          address: {
            addressLine1: "1 Lonely Street",
            addressLine2: nil,
            addressLine3: nil,
            addressLine4: nil,
            town: "Post-Town0",
            postcode: "A0 0AA",
          },
        },
      }
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end
  end
end
