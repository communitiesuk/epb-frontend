# frozen_string_literal: true

describe UseCase::FindCertificateByStreetNameAndTown do
  context 'when there missing parameters' do
    let(:certificates_gateway) { CertificatesGateway::EmptyStub.new }
    let(:find_certificate) { described_class.new(certificates_gateway) }

    it 'raises an error when both are missing' do
      expect { find_certificate.execute('', '') }.to raise_error(
        Errors::AllParamsMissing
      )
    end
    it 'raises an error when street name is missing' do
      expect { find_certificate.execute('', 'Nowhere Special') }.to raise_error(
        Errors::StreetNameMissing
      )
    end
    it 'raises an error when town is missing' do
      expect { find_certificate.execute('Somewhere Empty', '') }.to raise_error(
        Errors::TownMissing
      )
    end
  end

  context 'when there are no certificates by that street name and town' do
    let(:certificates_gateway) { CertificatesGateway::EmptyStub.new }
    let(:find_certificate) { described_class.new(certificates_gateway) }

    it 'returns empty array' do
      expect {
        find_certificate.execute('Somewhere Empty', 'Nowhere Special')
      }.to raise_error(Errors::CertificateNotFound)
    end
  end

  context 'when there are certificates with that street name and town' do
    let(:valid_certificates) do
      [
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
          addressLine1: 'Marsham Street',
          town: 'London',
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
          addressLine1: 'Marsham Street',
          town: 'London',
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
          addressLine1: 'Marsham Street',
          town: 'London',
          heatDemand: {
            currentSpaceHeatingDemand: 222,
            currentWaterHeatingDemand: 321,
            impactOfLoftInsulation: 79,
            impactOfCavityInsulation: 67,
            impactOfSolidWallInsulation: 69
          }
        }
      ]
    end

    let(:certificates_gateway) { CertificatesGateway::Stub.new }
    let(:find_certificate) { described_class.new(certificates_gateway) }

    it 'returns list of certificates' do
      expect(
        find_certificate.execute('Marsham Street', 'London')[:data][
          :assessments
        ]
      ).to eq(valid_certificates)
    end
  end
end
