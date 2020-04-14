# frozen_string_literal: true

module CertificatesGateway
  class Stub
    def initialize(recommended_improvements = false)
      @recommended_improvements = recommended_improvements
    end
    def search_by_postcode(*)
      {
        data: {
          assessments: [
            {
              assessmentId: '123-456',
              dateOfAssessment: '2011-01-01',
              dateRegistered: '2011-01-02',
              dwellingType: 'Top floor flat',
              typeOfAssessment: 'RdSAP',
              totalFloorArea: 50,
              addressSummary: '2 Marsham Street, London, SW1B 2BB',
              currentEnergyEfficiencyRating: 90,
              currentEnergyEfficiencyBand: 'b',
              potentialEnergyEfficiencyRating: 'a',
              potentialEnergyEfficiencyBand: 95,
              postcode: 'SW1B 2BB',
              dateOfExpiry: '2021-01-01',
              heatDemand: {
                currentSpaceHeatingDemand: 222,
                currentWaterHeatingDemand: 321,
                impactOfLoftInsulation: 79,
                impactOfCavityInsulation: 67,
                impactOfSolidWallInsulation: 69
              }
            },
            {
              assessmentId: '123-987',
              dateOfAssessment: '2011-01-01',
              dateRegistered: '2011-01-02',
              dwellingType: 'Top floor flat',
              typeOfAssessment: 'RdSAP',
              totalFloorArea: 50,
              addressSummary: '1 Marsham Street, London, SW1B 2BB',
              currentEnergyEfficiencyRating: 90,
              currentEnergyEfficiencyBand: 'b',
              potentialEnergyEfficiencyRating: 'a',
              potentialEnergyEfficiencyBand: 95,
              postcode: 'SW1B 2BB',
              dateOfExpiry: '2022-01-01',
              heatDemand: {
                currentSpaceHeatingDemand: 222,
                currentWaterHeatingDemand: 321,
                impactOfLoftInsulation: 79,
                impactOfCavityInsulation: 67,
                impactOfSolidWallInsulation: 69
              }
            },
            {
              assessmentId: '123-456',
              dateOfAssessment: '2011-01-01',
              dateRegistered: '2011-01-02',
              dwellingType: 'Top floor flat',
              typeOfAssessment: 'RdSAP',
              totalFloorArea: 50,
              addressSummary: '3 Marsham Street, London, SW1B 2BB',
              currentEnergyEfficiencyRating: 90,
              currentEnergyEfficiencyBand: 'b',
              potentialEnergyEfficiencyRating: 'a',
              potentialEnergyEfficiencyBand: 95,
              postcode: 'SW1B 2BB',
              dateOfExpiry: '2023-01-01',
              heatDemand: {
                currentSpaceHeatingDemand: 222,
                currentWaterHeatingDemand: 321,
                impactOfLoftInsulation: 79,
                impactOfCavityInsulation: 67,
                impactOfSolidWallInsulation: 69
              }
            }
          ]
        },
        meta: { "searchPostcode": 'SW1 5RW' }
      }
    end

    def search_by_id(*)
      {
        data: {
          assessments: [
            {
              assessmentId: '123-456',
              dateOfAssessment: '2011-01-01',
              dateRegistered: '2011-01-02',
              dwellingType: 'Top floor flat',
              typeOfAssessment: 'RdSAP',
              totalFloorArea: 50,
              addressSummary: '3 Marsham Street, London, SW1B 2BB',
              currentEnergyEfficiencyRating: 90,
              currentEnergyEfficiencyBand: 'b',
              potentialEnergyEfficiencyRating: 'a',
              potentialEnergyEfficiencyBand: 95,
              postcode: 'SW1B 2BB',
              dateOfExpiry: '2023-01-01',
              heatDemand: {
                currentSpaceHeatingDemand: 222,
                currentWaterHeatingDemand: 321,
                impactOfLoftInsulation: 79,
                impactOfCavityInsulation: 67,
                impactOfSolidWallInsulation: 69
              }
            }
          ]
        },
        meta: { "searchPostcode": 'SW1 5RW' }
      }
    end

    def search_by_street_name_and_town(street_name, town)
      {
        data: {
          assessments: [
            {
              assessmentId: '1234-5678-9101-1121',
              dateOfAssessment: '2011-01-01',
              dateRegistered: '2011-01-02',
              dwellingType: 'Top floor flat',
              typeOfAssessment: 'RdSAP',
              totalFloorArea: 50,
              addressSummary: '2 Marsham Street, London, SW1B 2BB',
              currentEnergyEfficiencyRating: 90,
              currentEnergyEfficiencyBand: 'b',
              potentialEnergyEfficiencyRating: 'a',
              potentialEnergyEfficiencyBand: 95,
              postcode: 'SW1B 2BB',
              dateOfExpiry: '2021-01-01',
              addressLine1: street_name,
              town: town,
              heatDemand: {
                currentSpaceHeatingDemand: 222,
                currentWaterHeatingDemand: 321,
                impactOfLoftInsulation: 79,
                impactOfCavityInsulation: 67,
                impactOfSolidWallInsulation: 69
              }
            },
            {
              assessmentId: '1234-5678-9101-1122',
              dateOfAssessment: '2011-01-01',
              dateRegistered: '2011-01-02',
              dwellingType: 'Top floor flat',
              typeOfAssessment: 'RdSAP',
              totalFloorArea: 50,
              addressSummary: '1 Marsham Street, London, SW1B 2BB',
              currentEnergyEfficiencyRating: 90,
              currentEnergyEfficiencyBand: 'b',
              potentialEnergyEfficiencyRating: 'a',
              potentialEnergyEfficiencyBand: 95,
              postcode: 'SW1B 2BB',
              dateOfExpiry: '2022-01-01',
              addressLine1: street_name,
              town: town,
              heatDemand: {
                currentSpaceHeatingDemand: 222,
                currentWaterHeatingDemand: 321,
                impactOfLoftInsulation: 79,
                impactOfCavityInsulation: 67,
                impactOfSolidWallInsulation: 69
              }
            },
            {
              assessmentId: '1234-5678-9101-1123',
              dateOfAssessment: '2011-01-01',
              dateRegistered: '2011-01-02',
              dwellingType: 'Top floor flat',
              typeOfAssessment: 'RdSAP',
              totalFloorArea: 50,
              addressSummary: '3 Marsham Street, London, SW1B 2BB',
              currentEnergyEfficiencyRating: 90,
              currentEnergyEfficiencyBand: 'b',
              potentialEnergyEfficiencyRating: 'a',
              potentialEnergyEfficiencyBand: 95,
              postcode: 'SW1B 2BB',
              dateOfExpiry: '2023-01-01',
              addressLine1: street_name,
              town: town,
              heatDemand: {
                currentSpaceHeatingDemand: 222,
                currentWaterHeatingDemand: 321,
                impactOfLoftInsulation: 79,
                impactOfCavityInsulation: 67,
                impactOfSolidWallInsulation: 69
              }
            }
          ]
        },
        meta: { "searchPostcode": 'SW1 5RW' }
      }
    end

    def fetch(assessment_id)
      if @recommended_improvements
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
            improvementCode: '3',
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

      {
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
          addressSummary: '2 Marsham Street, London, SW1B 2BB',
          assessmentId: assessment_id,
          dateOfAssessment: '02 January 2020',
          dateRegistered: '05 January 2020',
          dateOfExpiry: '05 January 2030',
          dwellingType: 'Top floor flat',
          typeOfAssessment: 'RdSAP',
          totalFloorArea: 150,
          currentEnergyEfficiencyRating: 90,
          currentEnergyEfficiencyBand: 'b',
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
  end
end
