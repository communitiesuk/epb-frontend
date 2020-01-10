# frozen_string_literal: true
describe Gateway::AssessorsGateway do
  include RSpecUnitMixin

  let(:gateway) do
    described_class.new(container.get_object(:internal_api_client))
  end

  context 'when an assessor exist' do
    let(:response) { gateway.search('SW1A+2AA') }

    let(:assessor) { response[:results].first[:assessor] }

    # TODO: Modify the test once implement the search by postcode api
    it 'checks the number of assessors returned from the api' do
      expect(response[:results].count).to eq(3)
    end

    it 'checks the shape of the object passed in the assessor object' do
      expect(assessor.keys).to contain_exactly(
        :firstName,
        :lastName,
        :contactDetails,
        :searchResultsComparisonPostcode,
        :registeredBy
      )
    end

    it 'checks the shape of the object passed in the contact details object' do
      expect(assessor[:contactDetails].keys).to contain_exactly(
        :email,
        :telephoneNumber
      )
    end

    it 'checks the shape of the object passed in the registeredBy object' do
      expect(assessor[:registeredBy].keys).to contain_exactly(:name, :schemeId)
    end
  end

  context 'when an assessor doesnt exist' do
    let(:response) { gateway.search('BF1+3AA') }

    it 'returns empty results' do
      expect(response).to eq({ results: [], searchPostcode: 'BF1 3AA' })
    end
  end
end
