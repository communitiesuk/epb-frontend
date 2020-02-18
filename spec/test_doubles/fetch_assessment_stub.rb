# frozen_string_literal: true

class FetchAssessmentStub
  def self.fetch(assessment_id)
    if assessment_id == '123-456'
      body = {
        addressSummary: '2 Marsham Street, London, SW1B 2BB',
        assessmentId: '123-456',
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
        postcode: 'SW1B 2BB'
      }
    else
      body = {
        addressSummary: '2 Marsham Street, London, SW1B 2BB',
        assessmentId: '223-456',
        dateRegistered: '2020-01-05',
        dateOfExpiry: '2030-01-05',
        dateOfAssessment: '2020-01-02',
        dwellingType: 'Top floor flat',
        typeOfAssessment: 'RdSAP',
        totalFloorArea: 150,
        currentEnergyEfficiencyRating: 25,
        currentEnergyEfficiencyBand: 'f',
        potentialEnergyEfficiencyRating: 99,
        potentialEnergyEfficiencyBand: 'a',
        postcode: 'SW1B 2BB'
      }
    end

    WebMock.stub_request(
      :get,
      "http://test-api.gov.uk/api/assessments/domestic-energy-performance/#{
        assessment_id
      }"
    )
      .to_return(
      status: 200,
      body: body.to_json
    )
  end
end
