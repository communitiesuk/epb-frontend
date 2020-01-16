describe 'find assessor by postcode' do
  include RSpecUnitMixin

  let(:internal_api_client) { container.get_object(:internal_api_client) }
  let(:assessors_gateway) { Gateway::AssessorsGateway.new(internal_api_client) }
  let(:find_assessor) { UseCase::FindAssessor.new(assessors_gateway) }

  context 'given valid postcode' do
    context 'where assessors are near' do
      let(:response) { find_assessor.execute('SW1A+2AA') }

      before do
        stub_request(
          :get,
          'http://test-api.gov.uk/api/assessors/search/SW1A+2AA'
        )
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

    context 'where no assessors are near' do
      before do
        stub_request(
          :get,
          'http://test-api.gov.uk/api/assessors/search/BF1+3AA'
        )
          .to_return(
          status: 200,
          body: { "results": [], "searchPostcode": 'BF1 3AA' }.to_json
        )
      end

      it 'returns empty results' do
        expect(find_assessor.execute('BF1+3AA')).to eq([])
      end
    end

    context 'where the postcode doesnt exist' do
      before do
        stub_request(
          :get,
          'http://test-api.gov.uk/api/assessors/search/B11+4AA'
        )
          .to_return(
          status: 200,
          body: {
            "errors": [
              {
                "code": 'NOT_FOUND',
                "message": 'The requested postcode is not registered'
              }
            ]
          }.to_json
        )
      end

      it 'raises postcode not registered exception' do
        expect {
          find_assessor.execute('B11+4AA')
        }.to raise_exception UseCase::FindAssessor::PostcodeNotRegistered
      end
    end

    context 'where the requested postcode is malformed' do
      before do
        stub_request(
          :get,
          'http://test-api.gov.uk/api/assessors/search/C11+3FF'
        )
          .to_return(
          status: 200,
          body: {
            "errors": [
              {
                "code": 'INVALID_REQUEST',
                "title": 'The requested postcode is not valid'
              }
            ]
          }.to_json
        )
      end

      it 'raises postcode not valid exception' do
        expect {
          find_assessor.execute('C11+3FF')
        }.to raise_exception UseCase::FindAssessor::PostcodeNotValid
      end
    end

    context 'where there is no scheme' do
      before do
        stub_request(
          :get,
          'http://test-api.gov.uk/api/assessors/search/F11+3FF'
        )
          .to_return(
          status: 200,
          body: {
            "errors": [
              {
                "code": 'SCHEME_NOT_FOUND',
                "message":
                  'There is no scheme for one of the requested assessor'
              }
            ]
          }.to_json
        )
      end

      it 'raises scheme not found exception' do
        expect {
          find_assessor.execute('F11+3FF')
        }.to raise_exception UseCase::FindAssessor::SchemeNotFound
      end
    end
  end
end
