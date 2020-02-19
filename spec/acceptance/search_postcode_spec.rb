# frozen_string_literal: true

describe 'Acceptance::Postcodes' do
  include RSpecUnitMixin

  let(:internal_api_client) { container.get_object(:internal_api_client) }
  let(:assessors_gateway) { Gateway::AssessorsGateway.new(internal_api_client) }
  let(:find_assessor) { UseCase::FindAssessorByPostcode.new(assessors_gateway) }

  context 'given valid postcode' do
    context 'where assessors are near' do
      let(:response) { find_assessor.execute('SW1A+2AA') }
      let(:assessor) { response.first[:assessor] }

      before { FindAssessorByPostcodeStub.search_by_postcode('SW1A+2AA') }

      it 'returns the number of assessors returned from the api' do
        expect(response.count).to eq(3)
      end

      it 'returns response keys for results object' do
        expect(response.first.keys).to contain_exactly(:assessor, :distance)
      end

      it 'returns response keys for assessor object' do
        expect(assessor.keys).to contain_exactly(
          :firstName,
          :lastName,
          :contactDetails,
          :searchResultsComparisonPostcode,
          :registeredBy
        )
      end

      it 'returns response keys for contactDetails object' do
        expect(assessor[:contactDetails].keys).to contain_exactly(
          :email,
          :telephoneNumber
        )
      end

      it 'returns response keys for registeredBy object' do
        expect(assessor[:registeredBy].keys).to contain_exactly(
          :name,
          :schemeId
        )
      end
    end

    context 'where no assessors are near' do
      before do
        FindAssessorByPostcodeNoNearAssessorsStub.search_by_postcode('BF1+3AA')
      end

      it 'returns empty results' do
        expect(find_assessor.execute('BF1+3AA')).to eq([])
      end
    end

    context 'where the postcode doesnt exist' do
      before do
        FindAssessorByPostcodeUnregisteredPostcodeStub.search_by_postcode(
          'B11+4AA'
        )
      end

      it 'raises postcode not registered exception' do
        expect {
          find_assessor.execute('B11+4AA')
        }.to raise_exception UseCase::FindAssessorByPostcode::PostcodeNotRegistered
      end
    end

    context 'where the requested postcode is malformed' do
      before do
        FindAssessorByPostcodeInvalidPostcodeStub.search_by_postcode('C11+3FF')
      end

      it 'raises postcode not valid exception' do
        expect {
          find_assessor.execute('C11+3FF')
        }.to raise_exception UseCase::FindAssessorByPostcode::PostcodeNotValid
      end
    end
  end
end
