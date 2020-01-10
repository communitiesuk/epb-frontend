describe 'find assessor by postcode' do
  include RSpecUnitMixin

  let(:internal_api_client) { container.get_object(:internal_api_client) }

  context 'given valid postcode' do
    let(:assessors_gateway) do
      Gateway::AssessorsGateway.new(internal_api_client)
    end
    let(:find_assessor) { UseCase::FindAssessor.new(assessors_gateway) }
    let(:response) { find_assessor.execute('SW1A+2AA') }

    # TODO: Modify test once implement the search by postcode api
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

  # TODO: Uncomment once implement the search by postcode api
  context 'given invalid postcode' do
    let(:assessors_gateway) do
      Gateway::AssessorsGateway.new(internal_api_client)
    end
    let(:find_assessor) { UseCase::FindAssessor.new(assessors_gateway) }
    let(:response) { find_assessor.execute('BF1+3AA') }

    it 'returns empty results' do
      expect(response).to eq([])
    end
  end
end
