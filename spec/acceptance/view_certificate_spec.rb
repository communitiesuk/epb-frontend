# frozen_string_literal: true

describe 'Acceptance::Certificate' do
  include RSpecFrontendServiceMixin

  context 'when the assessment exists' do
    before { FetchAssessment::Stub.fetch('123-456') }

    let(:response) { get '/energy-performance-certificate/123-456' }

    it 'returns status 200' do
      expect(response.status).to eq(200)
    end

    it 'shows the EPC title' do
      expect(response.body).to include('Energy Performance Certificate')
    end

    it 'shows the address summary' do
      expect(response.body).to include('2 Marsham Street, London, SW1B 2BB')
    end

    it 'shows the certificate number' do
      expect(response.body).to include('123-456')
    end

    it 'shows the date of assessment' do
      expect(response.body).to include('05 January 2020')
    end

    it 'shows the registered date of the certificate' do
      expect(response.body).to include('02 January 2020')
    end

    it 'shows the type of assessment' do
      expect(response.body).to include('RdSAP')
    end

    it 'shows the total floor area' do
      expect(response.body).to include('150')
    end

    it 'shows the type of dwelling' do
      expect(response.body).to include('Top floor flat')
    end

    it 'shows the SVG with energy ratings' do
      expect(response.body).to include('<svg width="615" height="400"')
    end
  end

  context 'when the assessment doesnt exist' do
    before { FetchAssessment::NoAssessmentStub.fetch }

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
