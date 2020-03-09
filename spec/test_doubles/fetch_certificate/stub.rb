# frozen_string_literal: true

module FetchCertificate
  class Stub
    def self.fetch(assessment_id)
      body = {
        addressSummary: '2 Marsham Street, London, SW1B 2BB',
        assessmentId: assessment_id,
        dateRegistered: '2020-01-05',
        dateOfExpiry: '2030-01-05',
        dateOfAssessment: '2020-01-02',
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
        town: 'London'
      }

      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/domestic-energy-performance/#{
          assessment_id
        }"
      )
        .to_return(status: 200, body: body.to_json)
    end
  end
end
