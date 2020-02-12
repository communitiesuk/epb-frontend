# frozen_string_literal: true

describe UseCase::FindCertificate do
  it 'returns an error when the postcode is not valid' do
    find_certificate_without_valid_postcode =
      described_class.new(CertificatesGatewayInvalidPostcodesStub.new)

    expect {
      find_certificate_without_valid_postcode.execute('E19 0GL')
    }.to raise_exception UseCase::FindCertificate::PostcodeNotValid
  end

  context 'when there are no certificates at the postcode' do
    let(:certificates_gateway) { CertificatesGatewayEmptyStub.new }
    let(:find_certificate) { described_class.new(certificates_gateway) }

    it 'returns empty array' do
      expect(find_certificate.execute('SW1A+2AA')).to eq([])
    end
  end

  context 'when there are certificates at the postcode' do
    let(:valid_certificates) do
      [
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
          dateOfExpiry: '2021-01-01'
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
          dateOfExpiry: '2022-01-01'
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
          dateOfExpiry: '2023-01-01'
        }
      ]
    end

    let(:certificates_gateway) { CertificatesGatewayStub.new }
    let(:find_certificate) { described_class.new(certificates_gateway) }

    it 'returns list of certificates' do
      expect(find_certificate.execute('SW1A+2AB')).to eq(valid_certificates)
    end
  end
end
