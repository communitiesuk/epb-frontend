# frozen_string_literal: true

module CertificatesGateway
  class Stub
    def initialize(recommended_improvements: false)
      @recommended_improvements = recommended_improvements
    end

    def search_by_postcode(*)
      {
        data: {
          assessments: [
            {
              assessmentId: "1234-5678-1234-5678-1234",
              dateOfAssessment: "2020-01-01",
              dateRegistered: "2020-01-02",
              dwellingType: "Top floor flat",
              typeOfAssessment: "RdSAP",
              totalFloorArea: 50,
              currentEnergyEfficiencyRating: 90,
              currentEnergyEfficiencyBand: "b",
              potentialEnergyEfficiencyRating: 95,
              potentialEnergyEfficiencyBand: "a",
              postcode: "SW1B 2BB",
              dateOfExpiry: "2032-01-01",
              relatedPartyDisclosureText: "Financial interest in the property",
              relatedPartyDisclosureNumber: nil,
              heatDemand: {
                currentSpaceHeatingDemand: 222,
                currentWaterHeatingDemand: 321,
                impactOfLoftInsulation: 79,
                impactOfCavityInsulation: 67,
                impactOfSolidWallInsulation: 69,
              },
            },
            {
              assessmentId: "3345-6789-2345-6789-2345",
              dateOfAssessment: "2020-01-01",
              dateRegistered: "2020-01-02",
              dwellingType: "Top floor flat",
              typeOfAssessment: "RdSAP",
              totalFloorArea: 50,
              currentEnergyEfficiencyRating: 90,
              currentEnergyEfficiencyBand: "b",
              potentialEnergyEfficiencyRating: 95,
              potentialEnergyEfficiencyBand: "a",
              postcode: "SW1B 2BB",
              dateOfExpiry: "2030-01-01",
              relatedPartyDisclosureText: nil,
              relatedPartyDisclosureNumber: 4,
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
        meta: {
          "searchPostcode": "SW1 5RW",
        },
      }
    end

    def search_by_id(assessment_id)
      if assessment_id == ""
        {
          "data": {
            "dateOfAssessment": "2020-05-04",
            "dateRegistered": "2020-05-04",
            "dwellingType": "Dwelling-Type0",
            "typeOfAssessment": "RdSAP",
            "totalFloorArea": 0.0,
            "assessmentId": "1111-1111-1111-1111-1112",
            "currentEnergyEfficiencyRating": 50,
            "potentialEnergyEfficiencyRating": 50,
            "postcode": "A0 0AA",
            "dateOfExpiry": "2030-05-04",
            "addressLine1": "1 Some Street",
            "addressLine2": "",
            "addressLine3": "",
            "addressLine4": "",
            "town": "Post-Town1",
            "relatedPartyDisclosureText": "Financial interest in the property",
            "relatedPartyDisclosureNumber": nil,
            "heatDemand": {
              "currentSpaceHeatingDemand": 30.0,
              "currentWaterHeatingDemand": 60.0,
              "impactOfLoftInsulation": -8,
              "impactOfCavityInsulation": -12,
              "impactOfSolidWallInsulation": -16,
            },
            "currentEnergyEfficiencyBand": "e",
            "potentialEnergyEfficiencyBand": "e",
            "recommendedImprovements": [
              {
                "sequence": 0,
                "improvementCode": "5",
                "indicativeCost": "5",
                "typicalSaving": "0.0",
                "improvementCategory": "6",
                "improvementType": "Z3",
                "energyPerformanceRatingImprovement": 50,
                "environmentalImpactRatingImprovement": 50,
                "greenDealCategoryCode": "1",
              },
              {
                "sequence": 1,
                "improvementCode": "1",
                "indicativeCost": "2",
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
              "registeredBy": {
                "name": "Quidos",
                "schemeId": 6,
              },
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
        {
          data: {
            assessments: [
              {
                assessmentId: "1234-5678-1234-5678-1234",
                dateOfAssessment: "2020-01-01",
                dateRegistered: "2020-01-02",
                dwellingType: "Top floor flat",
                typeOfAssessment: "RdSAP",
                totalFloorArea: 50,
                currentEnergyEfficiencyRating: 90,
                currentEnergyEfficiencyBand: "b",
                potentialEnergyEfficiencyRating: 95,
                potentialEnergyEfficiencyBand: "a",
                postcode: "SW1B 2BB",
                dateOfExpiry: "2032-01-01",
                relatedPartyDisclosureText: nil,
                relatedPartyDisclosureNumber: 2,
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
          meta: {
            "searchPostcode": "SW1 5RW",
          },
        }
      end
    end

    def search_by_street_name_and_town(street_name, town, _assessment_types)
      {
        data: {
          assessments: [
            {
              assessmentId: "4567-6789-4567-6789-4567",
              dateOfAssessment: "2020-01-01",
              dateRegistered: "2020-01-02",
              dwellingType: "Top floor flat",
              typeOfAssessment: "RdSAP",
              totalFloorArea: 50,
              currentEnergyEfficiencyRating: 90,
              currentEnergyEfficiencyBand: "b",
              potentialEnergyEfficiencyRating: 95,
              potentialEnergyEfficiencyBand: "a",
              postcode: "SW1B 2BB",
              dateOfExpiry: "2030-01-01",
              addressLine1: street_name,
              town:,
              relatedPartyDisclosureText: "Financial interest in the property",
              relatedPartyDisclosureNumber: nil,
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
              typeOfAssessment: "RdSAP",
              totalFloorArea: 50,
              currentEnergyEfficiencyRating: 90,
              currentEnergyEfficiencyBand: "b",
              potentialEnergyEfficiencyRating: 95,
              potentialEnergyEfficiencyBand: "a",
              postcode: "SW1B 2BB",
              dateOfExpiry: "2030-01-01",
              addressLine1: street_name,
              town:,
              relatedPartyDisclosureText: "No related party",
              relatedPartyDisclosureNumber: nil,
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
              typeOfAssessment: "RdSAP",
              totalFloorArea: 50,
              currentEnergyEfficiencyRating: 90,
              currentEnergyEfficiencyBand: "b",
              potentialEnergyEfficiencyRating: 95,
              potentialEnergyEfficiencyBand: "a",
              postcode: "SW1B 2BB",
              dateOfExpiry: "2032-01-01",
              addressLine1: street_name,
              town:,
              relatedPartyDisclosureText: nil,
              relatedPartyDisclosureNumber: 1,
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
        meta: {
          "searchPostcode": "SW1 5RW",
        },
      }
    end

    def fetch(assessment_id)
      recommended_improvements =
        if @recommended_improvements
          [
            {
              energyPerformanceRatingImprovement: 76,
              environmentalImpactRatingImprovement: 72,
              greenDealCategoryCode: "3",
              improvementCategory: "5",
              improvementCode: "1",
              improvementDescription: null,
              improvementTitle: "",
              improvementType: "Q",
              indicativeCost: "£200 - £500",
              sequence: 3,
              typicalSaving: "100",
              energyPerformanceBandImprovement: "c",
            },
            {
              energyPerformanceRatingImprovement: 76,
              environmentalImpactRatingImprovement: 72,
              greenDealCategoryCode: "3",
              improvementCategory: "5",
              improvementCode: "2",
              improvementDescription: null,
              improvementTitle: "",
              improvementType: "Q",
              indicativeCost: "£500 - £1000",
              sequence: 1,
              typicalSaving: "900",
              energyPerformanceBandImprovement: "c",
            },
            {
              energyPerformanceRatingImprovement: 76,
              environmentalImpactRatingImprovement: 72,
              greenDealCategoryCode: "3",
              improvementCategory: "5",
              improvementCode: "3",
              improvementDescription: null,
              improvementTitle: "",
              improvementType: "Q",
              indicativeCost: "£300 - £400",
              sequence: 2,
              typicalSaving: "9000",
              energyPerformanceBandImprovement: "c",
            },
          ]
        else
          []
        end

      {
        data: {
          assessor: {
            firstName: "Test",
            lastName: "Boi",
            registeredBy: {
              name: "Quidos",
              schemeId: 1,
            },
            schemeAssessorId: "TESTASSESSOR",
            dateOfBirth: "2019-12-04",
            contactDetails: {
              telephoneNumber: "12345678901",
              email: "test.boi@quidos.com",
            },
            searchResultsComparisonPostcode: "SW1A 2AA",
            qualifications: {
              domesticRdSap: "ACTIVE",
            },
          },
          assessmentId: assessment_id,
          dateOfAssessment: "02 January 2020",
          dateRegistered: "05 January 2020",
          dateOfExpiry: "05 January 2030",
          dwellingType: "Top floor flat",
          typeOfAssessment: "RdSAP",
          totalFloorArea: 150,
          currentEnergyEfficiencyRating: 90,
          currentEnergyEfficiencyBand: "b",
          potentialEnergyEfficiencyRating: 99,
          potentialEnergyEfficiencyBand: "a",
          postcode: "SW1B 2BB",
          addressLine1: "Flat 33",
          addressLine2: "2 Marsham Street",
          addressLine3: "",
          addressLine4: "",
          town: "London",
          heatDemand: {
            currentSpaceHeatingDemand: 222,
            currentWaterHeatingDemand: 321,
            impactOfLoftInsulation: 79,
            impactOfCavityInsulation: 67,
            impactOfSolidWallInsulation: 69,
          },
          recommendedImprovements: recommended_improvements,
          relatedPartyDisclosureText: nil,
          relatedPartyDisclosureNumber: 1,
        },
      }
    end
  end
end
