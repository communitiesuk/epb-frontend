# frozen_string_literal: true

module FetchCertificate
  class Stub
    def self.fetch(
      assessment_id,
      current_rating = 90,
      current_band = 'b',
      recommended_improvements = false
    )
      if assessment_id == '1111-1111-1111-1111-1112'
        body = {
          "data": {
            "dateOfAssessment": "2006-05-04",
            "dateRegistered": "2006-05-04",
            "dwellingType": "Dwelling-Type0",
            "typeOfAssessment": "RdSAP",
            "totalFloorArea": 0.0,
            "assessmentId": "1111-1111-1111-1111-1112",
            "addressSummary": "1 Some Street, Post-Town1, A0 0AA",
            "currentEnergyEfficiencyRating": 50,
            "potentialEnergyEfficiencyRating": 50,
            "postcode": "A0 0AA",
            "dateOfExpiry": "2016-05-04",
            "addressLine1": "1 Some Street",
            "addressLine2": "",
            "addressLine3": "",
            "addressLine4": "",
            "town": "Post-Town1",
            "heatDemand": {
              "currentSpaceHeatingDemand": 30.0,
              "currentWaterHeatingDemand": 60.0,
              "impactOfLoftInsulation": -8,
              "impactOfCavityInsulation": -12,
              "impactOfSolidWallInsulation": -16
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
                "greenDealCategoryCode": "1"
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
                "greenDealCategoryCode": "3"
              }
            ],
            "assessor": {
              "firstName": "Kevin",
              "lastName": "Keenoy",
              "registeredBy": {
                "name": "Quidos",
                "schemeId": 6
              },
              "schemeAssessorId": "3",
              "dateOfBirth": "1994-01-01",
              "contactDetails": {
                "email": "kevin.keenoy@epb-assessors.com",
                "telephoneNumber": "04150859"
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
                "nonDomesticNos5": "INACTIVE"
              }
            }
          },
          "meta": {}
        }
      else
        if recommended_improvements
          recommendedImprovements = [
            {
              sequence: 3,
              indicativeCost: '£200 - £500',
              typicalSaving: 100.00,
              improvementCode: '1',
              improvementCategory: 'string',
              improvementType: 'string',
              energyPerformanceRating: 'C',
              environmentalImpactRating: 'string',
              greenDealCategoryCode: 'string'
            },
            {
              sequence: 1,
              indicativeCost: '£500 - £1000',
              typicalSaving: 900.00,
              improvementCode: '2',
              improvementCategory: 'string',
              improvementType: 'string',
              energyPerformanceRating: 'C',
              environmentalImpactRating: 'string',
              greenDealCategoryCode: 'string'
            },
            {
              sequence: 2,
              indicativeCost: '£300 - £400',
              typicalSaving: 9000.00,
              improvementCode: '8',
              improvementCategory: 'string',
              improvementType: 'string',
              energyPerformanceRating: 'C',
              environmentalImpactRating: 'string',
              greenDealCategoryCode: 'string'
            }
          ]
        else
          recommendedImprovements = []
        end

        body = {
          data: {
            assessor: {
              firstName: 'Test',
              lastName: 'Boi',
              registeredBy: { name: 'Quidos', schemeId: 1 },
              schemeAssessorId: 'TESTASSESSOR',
              dateOfBirth: '2019-12-04',
              contactDetails: {
                telephoneNumber: '12345678901', email: 'test.boi@quidos.com'
              },
              searchResultsComparisonPostcode: 'SW1A 2AA',
              qualifications: { domesticRdSap: 'ACTIVE' }
            },
            addressSummary: 'Flat 33, 2 Marsham Street, London, SW1B 2BB',
            assessmentId: assessment_id,
            dateRegistered: '2020-01-05',
            dateOfExpiry: '2030-01-05',
            dateOfAssessment: '2020-01-02',
            dwellingType: 'Top floor flat',
            typeOfAssessment: 'RdSAP',
            totalFloorArea: 150,
            currentEnergyEfficiencyRating: current_rating,
            currentEnergyEfficiencyBand: current_band,
            potentialEnergyEfficiencyRating: 99,
            potentialEnergyEfficiencyBand: 'a',
            postcode: 'SW1B 2BB',
            addressLine1: 'Flat 33',
            addressLine2: '2 Marsham Street',
            addressLine3: '',
            addressLine4: '',
            town: 'London',
            heatDemand: {
              currentSpaceHeatingDemand: 222,
              currentWaterHeatingDemand: 321,
              impactOfLoftInsulation: 79,
              impactOfCavityInsulation: 67,
              impactOfSolidWallInsulation: 69
            },
            recommendedImprovements: recommendedImprovements
          }
        }
      end

      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/domestic-epc/#{assessment_id}"
      )
        .to_return(status: 200, body: body.to_json)
    end
  end
end
