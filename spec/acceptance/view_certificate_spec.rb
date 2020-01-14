# frozen_string_literal: true

describe 'view certificate' do
  context 'when the assessment exists' do
    before do
      stub_request(
        :get,
        'http://test-api.gov.uk/api/assessments/domestic-energy-performance/123-456'
      )
        .to_return(status: 200, body: {}.to_json)
    end

    let(:response) { get '/energy-performance-certificate/123-456' }

    it 'returns status 200' do
      expect(response.status).to eq(200)
    end

    it 'shows the EPC title' do
      expect(response.body).to include(
        'Energy performance certificate'
      )
    end
  end
  context 'when the assessment doesnt exist' do
    before do
      stub_request(
        :get,
        'http://test-api.gov.uk/api/assessments/domestic-energy-performance/123-456'
      )
        .to_return(
        status: 404, body: { 'error': 'cant find assessment' }.to_json
      )
    end

    let(:response) { get '/energy-performance-certificate/123-456' }

    it 'returns status 404' do
      expect(response.status).to eq(404)
    end

    it 'shows the error page' do
      expect(response.body).to include(
        '<h1 class="govuk-heading-xl">Page not found</h1>'
      )
    end
  end
end
