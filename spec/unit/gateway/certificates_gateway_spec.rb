# frozen_string_literal: true

describe Gateway::CertificatesGateway do
  include RSpecUnitMixin

  let(:gateway) do
    described_class.new(container.get_object(:internal_api_client))
  end

  context 'when a certificate exist' do
    let(:response) { gateway.search_by_postcode('SW1A+2AA') }

    let(:certificate) { response[:results].first }
    before { FindCertificate::Stub.search_by_postcode('SW1A+2AA') }

    it 'checks the number of certificates returned from the api' do
      expect(response[:results].count).to eq(3)
    end

    it 'checks the shape of the object passed in the certificate object' do
      expect(certificate.keys).to contain_exactly(
        :assessmentId,
        :dateOfAssessment,
        :dateRegistered,
        :dwellingType,
        :typeOfAssessment,
        :totalFloorArea,
        :addressSummary,
        :currentEnergyEfficiencyRating,
        :currentEnergyEfficiencyBand,
        :potentialEnergyEfficiencyRating,
        :potentialEnergyEfficiencyBand,
        :postcode,
        :dateOfExpiry
      )
    end
  end

  context 'when a certificate doesnt exist' do
    let(:response) { gateway.search_by_postcode('BF1 3AA') }

    before { FindCertificate::NoCertificatesStub.search_by_postcode }

    it 'returns empty results' do
      expect(response).to eq(results: [], searchPostcode: 'BF1 3AA')
    end
  end

  context 'when the postcode is not valid' do
    let(:response) { gateway.search_by_postcode('1+3AA') }

    before { FindCertificate::InvalidPostcodeStub.search_by_postcode('1+3AA') }

    it 'returns invalid request error' do
      expect(response).to eq(
        "errors": [
          {
            "code": 'INVALID_REQUEST',
            "title": 'The requested postcode is not valid'
          }
        ]
      )
    end
  end
end
