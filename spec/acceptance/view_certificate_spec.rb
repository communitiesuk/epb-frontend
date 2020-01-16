# frozen_string_literal: true

describe 'Acceptance::Certificate' do
  include RSpecFrontendServiceMixin

  context 'when the assessment exists' do
    before do
      stub_request(
        :get,
        'http://test-api.gov.uk/api/assessments/domestic-energy-performance/123-456'
      )
        .to_return(
        status: 200,
        body: {
          addressSummary: '2 Marsham Street, London, SW1B 2BB',
          assessmentId: '123-456'
        }.to_json
      )
    end

    let(:response) { get '/energy-performance-certificate/123-456' }

    it 'returns status 200' do
      expect(response.status).to eq(200)
    end

    it 'shows the EPC title' do
      expect(response.body).to include('Energy performance certificate')
    end

    it 'shows the address summary' do
      expect(response.body).to include('2 Marsham Street, London, SW1B 2BB')
    end

    it 'shows the certificate number' do
      expect(response.body).to include('123-456')
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
