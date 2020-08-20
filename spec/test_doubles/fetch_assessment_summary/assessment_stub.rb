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
            contactDetails: { email: "a@b.c", telephone: "07921921369" },
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
      assessment_id: "0000-0000-0000-0000-0001",
      date_of_expiry: "2030-01-01",
      related_assessments: true,
      related_party: nil
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
            issueDate: "2020-05-14",
            relatedPartyDisclosure: related_party,
            relatedRrn: "4192-1535-8427-8844-6702",
          },
          assessor: {
            name: "TEST NAME BOI",
            schemeAssessorId: "SPEC000000",
            registeredBy: { name: "test scheme", schemeId: 1 },
            companyDetails: {
              address: "123 My Street, My City, AB3 4CD", name: "Joe Bloggs Ltd"
            },
            contactDetails: {
              email: "test@testscheme.com", telephone: "012345"
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
          shortPaybackRecommendations: [
            {
              code: "1",
              text:
                "Consider thinking about maybe possibly getting a solar panel but only one.",
              cO2Impact: "MEDIUM",
            },
            {
              code: "2",
              text:
                "Consider introducing variable speed drives (VSD) for fans, pumps and compressors.",
              cO2Impact: "LOW",
            },
          ],
          mediumPaybackRecommendations: [
            {
              code: "3",
              text:
                "Engage experts to propose specific measures to reduce hot waterwastage and plan to carry this out.",
              cO2Impact: "LOW",
            },
          ],
          longPaybackRecommendations: [
            {
              code: "4",
              text: "Consider replacing or improving glazing.",
              cO2Impact: "LOW",
            },
          ],
          otherRecommendations: [
            { code: "5", text: "Add a big wind turbine.", cO2Impact: "HIGH" },
          ],
          energyBandFromRelatedCertificate: "a",
          relatedRrn: "0000-0000-0000-0000-1111",
        },
      }
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end

    def self.fetch_sap(*args)
      fetch_rdsap(args)
    end

    def self.fetch_rdsap(
      assessment_id,
      current_rating = 90,
      current_band = "b",
      recommended_improvements = false,
      current_carbon_emission = 2.4,
      potential_carbon_emission = 1.4,
      impact_of_loft_insulation = -79,
      impact_of_cavity_insulation = -67,
      impact_of_solid_wall_insulation = -69,
      related_party_disclosure_text = nil,
      related_party_disclosure_number = 1,
      property_summary = nil,
      type_of_assessment = "RdSAP",
      energy_performance_rating_improvement = 76,
      green_deal_plan = nil,
      estimatedEnergyCost = nil,
      potentialEnergySaving = nil
    )
      FetchAssessmentSummary::AssessmentSummaryErrorStub.fetch(assessment_id)
      property_summary ||= generate_property_summary
      green_deal_plan ||= generate_green_deal_plan

      if assessment_id == "1111-1111-1111-1111-1112"
        body = {
          "data": {
            "dateOfAssessment": "2020-05-04",
            "dateRegistered": "2020-05-04",
            "dwellingType": "Dwelling-Type0",
            "typeOfAssessment": "RdSAP",
            "totalFloorArea": 0.0,
            "assessmentId": "1111-1111-1111-1111-1112",
            "currentEnergyEfficiencyRating": 50,
            "potentialEnergyEfficiencyRating": 50,
            "currentCarbonEmission": 4.4,
            "potentialCarbonEmission": 3.4,
            "postcode": "A0 0AA",
            "dateOfExpiry": "2030-05-04",
            "addressLine1": "1 Some Street",
            "addressLine2": "",
            "addressLine3": "",
            "addressLine4": "",
            "town": "Post-Town1",
            estimatedEnergyCost: estimatedEnergyCost,
            potentialEnergySaving: potentialEnergySaving,
            "heatDemand": {
              "currentSpaceHeatingDemand": 30.0,
              "currentWaterHeatingDemand": 60.0,
              "impactOfLoftInsulation": -8,
              "impactOfCavityInsulation": -12,
              "impactOfSolidWallInsulation": -16,
            },
            "currentEnergyEfficiencyBand": "e",
            "potentialEnergyEfficiencyBand": "e",
            "relatedPartyDisclosureText": "Financial interest in the property",
            "relatedPartyDisclosureNumber": nil,
            "propertySummary": [],
            "relatedAssessments": [],
            "recommendedImprovements": [
              {
                "sequence": 0,
                "improvementCode": "",
                "improvementTitle": "Fix the boiler",
                "improvementDescription":
                  "An informative description of how to fix the boiler",
                "indicativeCost": "",
                "typicalSaving": "0.0",
                "improvementCategory": "6",
                "improvementType": "Z3",
                "energyPerformanceRatingImprovement":
                  energy_performance_rating_improvement,
                "environmentalImpactRatingImprovement": 50,
                "greenDealCategoryCode": "1",
              },
              {
                "sequence": 1,
                "improvementCode": "1",
                "improvementTitle": "",
                "improvementDescription": "",
                "indicativeCost": "",
                "typicalSaving": "0.1",
                "improvementCategory": "2",
                "improvementType": "Z2",
                "energyPerformanceRatingImprovement": 60,
                "environmentalImpactRatingImprovement": 64,
                "greenDealCategoryCode": "3",
              },
            ],
            "assessor": {
              "firstName": "Kevin",
              "lastName": "Keenoy",
              "registeredBy": { "name": "Quidos", "schemeId": 6 },
              "schemeAssessorId": "3",
              "dateOfBirth": "1994-01-01",
              "contactDetails": {
                "email": "kevin.keenoy@epb-assessors.com",
                "telephoneNumber": "04150859",
              },
              "searchResultsComparisonPostcode": "TQ11 0EG",
              "qualifications": {
                "domesticSap": "INACTIVE",
                "domesticRdSap": "ACTIVE",
                "nonDomesticSp3": "ACTIVE",
                "nonDomesticCc4": "ACTIVE",
                "nonDomesticDec": "INACTIVE",
                "nonDomesticNos3": "ACTIVE",
                "nonDomesticNos4": "ACTIVE",
                "nonDomesticNos5": "INACTIVE",
              },
            },
          },
          "meta": {},
        }
      else
        recommended_improvements =
          if recommended_improvements
            [
              {
                sequence: 3,
                indicativeCost: "£200 - £500",
                typicalSaving: 100.00,
                improvementCode: "1",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 96,
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 1,
                indicativeCost: "£500 - £1000",
                typicalSaving: 900.00,
                improvementCode: "2",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 60,
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 2,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 4,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 5,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 6,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 7,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 8,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 9,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 10,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 76,
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
              {
                sequence: 11,
                indicativeCost: "£300 - £400",
                typicalSaving: 9000.00,
                improvementCode: "8",
                improvementCategory: "string",
                improvementType: "string",
                energyPerformanceRatingImprovement: 99,
                environmentalImpactRatingImprovement: "string",
                greenDealCategoryCode: "string",
              },
            ]
          else
            []
          end

        body = {
          data: {
            assessor: {
              firstName: "Test",
              lastName: "Boi",
              registeredBy: { name: "Elmhurst Energy", schemeId: 1 },
              schemeAssessorId: "TESTASSESSOR",
              dateOfBirth: "2019-12-04",
              contactDetails: {
                telephoneNumber: "12345678901", email: "test.boi@quidos.com"
              },
              searchResultsComparisonPostcode: "SW1A 2AA",
              qualifications: { domesticRdSap: "ACTIVE" },
            },
            assessmentId: assessment_id,
            dateRegistered: "2020-01-05",
            dateOfExpiry: "2030-01-05",
            dateOfAssessment: "2020-01-02",
            dwellingType: "Top floor flat",
            typeOfAssessment: type_of_assessment,
            totalFloorArea: 150,
            currentEnergyEfficiencyRating: current_rating,
            currentEnergyEfficiencyBand: current_band,
            currentCarbonEmission: current_carbon_emission,
            potentialCarbonEmission: potential_carbon_emission,
            potentialEnergyEfficiencyRating: 99,
            potentialEnergyEfficiencyBand: "a",
            postcode: "SW1B 2BB",
            addressLine1: "Flat 33",
            addressLine2: "2 Marsham Street",
            addressLine3: "",
            addressLine4: "",
            town: "London",
            estimatedEnergyCost: "689.83",
            potentialEnergySaving: "174.00",
            heatDemand: {
              currentSpaceHeatingDemand: 222,
              currentWaterHeatingDemand: 321,
              impactOfLoftInsulation: impact_of_loft_insulation,
              impactOfCavityInsulation: impact_of_cavity_insulation,
              impactOfSolidWallInsulation: impact_of_solid_wall_insulation,
            },
            recommendedImprovements: recommended_improvements,
            relatedPartyDisclosureText: related_party_disclosure_text,
            relatedPartyDisclosureNumber: related_party_disclosure_number,
            propertySummary: property_summary,
            greenDealPlan: green_deal_plan,
            relatedAssessments: [
              {
                assessmentExpiryDate: "2006-05-04",
                assessmentId: "0000-0000-0000-0000-0001",
                assessmentStatus: "EXPIRED",
                assessmentType: "CEPC",
              },
              {
                assessmentExpiryDate: "2002-07-01",
                assessmentId: "0000-0000-0000-0000-0002",
                assessmentStatus: "EXPIRED",
                assessmentType: "CEPC-RR",
              },
            ],
          },
        }
      end

      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/#{assessment_id}/summary",
      ).to_return(status: 200, body: body.to_json)
    end

    def self.generate_green_deal_plan
      {
        greenDealPlanId: "ABC123456DEF",
        startDate: "2020-01-30",
        endDate: "2030-02-28",
        providerDetails: {
          name: "The Bank",
          telephone: "0800 0000000",
          email: "lender@example.com",
        },
        interest: { rate: 12.3, fixed: true },
        chargeUplift: { amount: 1.25, date: "2025-03-29" },
        ccaRegulated: true,
        structureChanged: false,
        measuresRemoved: false,
        measures: [
          {
            sequence: 0,
            measureType: "Loft insulation",
            product: "WarmHome lagging stuff (TM)",
            repaidDate: "2025-03-29",
          },
          {
            sequence: 1,
            measureType: "Double glazing",
            product: "Not applicable",
          },
        ],
        charges: [
          {
            sequence: 0,
            startDate: "2020-03-29",
            endDate: "2030-03-29",
            dailyCharge: "0.33",
          },
          {
            sequence: 1,
            startDate: "2020-03-29",
            endDate: "2030-03-29",
            dailyCharge: "0.01",
          },
        ],
        savings: [
          { fuelCode: "39", fuelSaving: 23_253, standingChargeFraction: 0 },
          { fuelCode: "40", fuelSaving: -6331, standingChargeFraction: -0.9 },
          { fuelCode: "41", fuelSaving: -15_561, standingChargeFraction: 0 },
        ],
        estimatedSavings: 1566,
      }
    end

    def self.generate_property_summary
      [
        { name: "wall", description: "Many walls", energyEfficiencyRating: 2 },
        {
          name: "secondary_heating",
          description: "Heating the house",
          energyEfficiencyRating: 5,
        },
        {
          name: "main_heating",
          description: "Room heaters, electric",
          energyEfficiencyRating: 3,
        },
        {
          name: "roof",
          description: "(another dwelling above)",
          energyEfficiencyRating: 0,
        },
      ]
    end
  end
end
