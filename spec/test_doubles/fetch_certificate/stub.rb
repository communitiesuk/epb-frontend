# frozen_string_literal: true

module FetchCertificate
  class Stub
    def self.fetch(
      assessment_id,
      current_rating = 90,
      current_band = 'b',
      recommended_improvements = false
    )
      if recommended_improvements
        recommendedImprovements = [{ sequence: 0 }, { sequence: 1 }]
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

      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/domestic-epc/#{assessment_id}"
      )
        .to_return(status: 200, body: body.to_json)
    end
  end
end
