describe 'find assessor by postcode' do
  include RSpecUnitMixin

  let(:internal_api_client) { container.get_object(:internal_api_client) }

  context 'given valid postcode' do
    let(:assessors_gateway) do
      Gateway::AssessorsGateway.new(internal_api_client)
    end
    let(:find_assessor) { UseCase::FindAssessor.new(assessors_gateway) }
    let(:response) { find_assessor.execute('SW1A+2AA') }

    before do
      stub_request(:get, 'http://test-api.gov.uk/api/assessors/search/SW1A+2AA')
        .to_return(
        status: 200,
        body: {
          "results": [
            {
              "assessor": {
                "firstName": 'Juan',
                "lastName": 'Uno',
                "contactDetails": {
                  "telephoneNumber": 'string', "email": 'user@example.com'
                },
                "searchResultsComparisonPostcode": 'SW1A 1AA',
                "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' }
              },
              "distance": 0.1
            },
            {
              "assessor": {
                "firstName": 'Doux',
                "lastName": 'Twose',
                "contactDetails": {
                  "telephoneNumber": 'string', "email": 'user@example.com'
                },
                "searchResultsComparisonPostcode": 'SW1A 1AA',
                "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' }
              },
              "distance": 0.26780459
            },
            {
              "assessor": {
                "firstName": 'Tri',
                "lastName": 'Triple',
                "contactDetails": {
                  "telephoneNumber": 'string', "email": 'user@example.com'
                },
                "searchResultsComparisonPostcode": 'SW1A 1AA',
                "registeredBy": { "schemeId": '432', "name": 'EPBs 4 U' }
              },
              "distance": 0.3
            }
          ],
          "searchPostcode": 'SW1A 2AA'
        }.to_json
      )
    end

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

  context 'given invalid postcode' do
    let(:assessors_gateway) do
      Gateway::AssessorsGateway.new(internal_api_client)
    end
    let(:find_assessor) { UseCase::FindAssessor.new(assessors_gateway) }
    let(:response) { find_assessor.execute('BF1+3AA') }
    before do
      stub_request(:get, 'http://test-api.gov.uk/api/assessors/search/BF1+3AA')
        .to_return(
        status: 200,
        body: { "results": [], "searchPostcode": 'BF1 3AA' }.to_json
      )
    end

    it 'returns empty results' do
      expect(response).to eq([])
    end
  end
end
