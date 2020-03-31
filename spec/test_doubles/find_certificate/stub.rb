# frozen_string_literal: true

module FindCertificate
  class Stub
    def self.search_by_postcode(postcode)
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/domestic-epc/search?postcode=#{
          postcode
        }"
      )
        .with(
        headers: {
          Accept: '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          Authorization: 'Bearer abc',
          'User-Agent' => 'Faraday v1.0.0'
        }
      )
        .to_return(
        status: 200,
        body: {
          "data": {
            "assessments": [
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
                dateOfExpiry: '2019-01-01',
                heatDemand: {
                  currentSpaceHeatingDemand: 222,
                  currentWaterHeatingDemand: 321,
                  impactOfLoftInsulation: 79,
                  impactOfCavityInsulation: 67,
                  impactOfSolidWallInsulation: 69
                },
                recommendedImprovements: []
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
                heatDemand: {
                  currentSpaceHeatingDemand: 222,
                  currentWaterHeatingDemand: 321,
                  impactOfLoftInsulation: 79,
                  impactOfCavityInsulation: 67,
                  impactOfSolidWallInsulation: 69
                },
                recommendedImprovements: [{ sequence: 0 }, { sequence: 1 }]
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
                heatDemand: {
                  currentSpaceHeatingDemand: 222,
                  currentWaterHeatingDemand: 321,
                  impactOfLoftInsulation: 79,
                  impactOfCavityInsulation: 67,
                  impactOfSolidWallInsulation: 69
                },
                recommendedImprovements: []
              }
            ]
          },
          "meta": { "searchPostcode": postcode }
        }.to_json
      )
    end

    def self.search_by_id(certificate_id)
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/domestic-epc/search?assessment_id=#{
          certificate_id
        }"
      )
        .with(
        headers: {
          Accept: '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          Authorization: 'Bearer abc',
          'User-Agent' => 'Faraday v1.0.0'
        }
      )
        .to_return(
        status: 200,
        body: {
          "data": {
            "assessments": [
              {
                assessmentId: certificate_id,
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
                dateOfExpiry: '2019-01-01',
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
          "meta": { "searchReferenceNumber": certificate_id }
        }.to_json
      )
    end

    def self.search_by_street_name_and_town(street_name, town)
      WebMock.stub_request(
        :get,
        "http://test-api.gov.uk/api/assessments/domestic-epc/search?street_name=#{
          street_name
        }&town=#{town}"
      )
        .with(
        headers: {
          Accept: '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          Authorization: 'Bearer abc',
          'User-Agent' => 'Faraday v1.0.0'
        }
      )
        .to_return(
        status: 200,
        body: {
          "data": {
            "assessments": [
              {
                assessmentId: '1234-5678-9101-1121-3141',
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
                dateOfExpiry: '2019-01-01',
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
          "meta": { "searchReferenceNumber": [street_name, town] }
        }.to_json
      )
    end
  end
end
