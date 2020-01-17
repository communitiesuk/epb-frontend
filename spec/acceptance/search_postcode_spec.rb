# frozen_string_literal: true

describe 'Acceptance::Postcodes' do
  include RSpecUnitMixin

  let(:internal_api_client) { container.get_object(:internal_api_client) }
  let(:assessors_gateway) { Gateway::AssessorsGateway.new(internal_api_client) }
  let(:find_assessor) { UseCase::FindAssessor.new(assessors_gateway) }

  context 'given valid postcode' do
    context 'where assessors are near' do
      let(:response) { find_assessor.execute('SW1A+2AA') }

      before { FindAssessorStub.search('SW1A+2AA') }

      it 'checks the number of assessors returned from the api' do
        expect(response.count).to eq(3)
      end

      it 'checks the response keys' do
        expect(response.first.keys).to contain_exactly(
          :fullName,
          :distance,
          :accreditationScheme,
          :schemeAssessorId,
          :telephoneNumber,
          :email
        )
      end
    end

    context 'where no assessors are near' do
      before { FindAssessorsNoNearAssessorsStub.search('BF1+3AA') }

      it 'returns empty results' do
        expect(find_assessor.execute('BF1+3AA')).to eq([])
      end
    end

    context 'where the postcode doesnt exist' do
      before { FindPostcodeUnregisteredPostcodeStub.search('B11+4AA') }

      it 'raises postcode not registered exception' do
        expect {
          find_assessor.execute('B11+4AA')
        }.to raise_exception UseCase::FindAssessor::PostcodeNotRegistered
      end
    end

    context 'where the requested postcode is malformed' do
      before { FindAssessorInvalidPostcodeStub.search('C11+3FF') }

      it 'raises postcode not valid exception' do
        expect {
          find_assessor.execute('C11+3FF')
        }.to raise_exception UseCase::FindAssessor::PostcodeNotValid
      end
    end

    context 'where there is no scheme' do
      before { FindAssessorNoSchemeStub.search('F11+3FF') }

      it 'raises scheme not found exception' do
        expect {
          find_assessor.execute('F11+3FF')
        }.to raise_exception UseCase::FindAssessor::SchemeNotFound
      end
    end
  end
end
