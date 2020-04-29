# frozen_string_literal: true

describe 'Acceptance::Certificate' do
  include RSpecFrontendServiceMixin

  context 'when the assessment exists' do
    before { FetchCertificate::Stub.fetch('123-456') }

    let(:response) { get '/energy-performance-certificate/123-456' }

    it 'returns status 200' do
      expect(response.status).to eq(200)
    end

    it 'shows the EPC title' do
      expect(response.body).to include('Energy Performance Certificate')
    end

    it 'shows the address summary' do
      expect(response.body).to include('2 Marsham Street')
      expect(response.body).to include('London')
      expect(response.body).to include('SW1B 2BB')
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

    it 'shows the date of expiry' do
      expect(response.body).to include('05 01 2030')
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
      expect(response.body).to include('<svg width="615" height="376"')
    end

    it 'shows the assessors full name' do
      expect(response.body).to include('Test Boi')
    end

    it 'shows the assessors accreditation scheme' do
      expect(response.body).to include('Quidos')
    end

    it 'shows the assessors accreditation number' do
      expect(response.body).to include('TESTASSESSOR')
    end

    it 'shows the assessors telephone number' do
      expect(response.body).to include('12345678901')
    end

    it 'shows the assessors email address' do
      expect(response.body).to include('test.boi@quidos.com')
    end

    it 'does not shows the warning to landlords that it cannot be rented out' do
      expect(response.body).to_not include(
                                     'The owner of this property may not be able to let it'
                                   )
    end

    it 'shows the current space heat demand' do
      expect(response.body).to include('222')
    end

    it 'shows the current water heat demand' do
      expect(response.body).to include('321')
    end

    it 'shows possible energy saving with loft insulation' do
      expect(response.body).to include('79')
    end

    it 'shows possible energy saving with cavity insulation' do
      expect(response.body).to include('67')
    end

    it 'shows possible energy saving with solid wall insulation' do
      expect(response.body).to include('69')
    end

    context 'when viewing environmental impact section' do
      it 'shows the summary text' do
        expect(response.body).to include(
          "The energy used for heating, lighting and power in our homes produces over a quarter of the UK's CO<sub>2</sub> emissions."
        )
      end

      it 'shows the carbon emissions of the property' do
        expect(response.body).to include('Average household produces')
        expect(response.body).to include('6')
        expect(response.body).to include('This property produces')
        expect(response.body).to include('2.4')
        expect(response.body).to include("This property's potential production")
        expect(response.body).to include('1.4')
      end
    end

    context 'with a poor (f) rating' do
      before { FetchCertificate::Stub.fetch('123-654', '25', 'f') }

      let(:response) { get '/energy-performance-certificate/123-654' }
      it 'shows a warning text' do
        expect(response.body).to include(
          'You may not be able to let this property'
        )
      end
    end

    context 'when there were no recommendations made' do
      it 'shows there aren’t any recommendations for this property text' do
        expect(response.body).to include(
          'There are no recommendations for this property.'
        )
      end
    end
  end

  context 'when the assessment exists with recommendations' do
    before { FetchCertificate::Stub.fetch('122-456', 90, 'b', true) }

    let(:response) { get '/energy-performance-certificate/122-456' }

    it 'returns status 200' do
      expect(response.status).to eq(200)
    end
    it 'shows making any of the recommended changes will improve your property’s energy efficiency text' do
      expect(response.body).to include(
        'Making any of the recommended changes will improve your property’s energy efficiency.'
      )
    end

    it 'doesnt show there aren’t any recommendations for this property text' do
      expect(response.body).not_to include(
                                     'There aren’t any recommendations for this property.'
                                   )
    end

    it 'shows recommendation title' do
      expect(response.body).to include(
        'Recommendation 2: Double glazed windows'
      )
    end

    it 'shows recommendation description' do
      expect(response.body).to include(
        'Replace single glazed windows with low-E double glazed windows'
      )
    end

    it 'shows typical saving cost' do
      expect(response.body).to include('£9,000')
    end

    it 'shows typical installation cost' do
      expect(response.body).to include('£300 - £400')
    end
  end

  context 'when viewing a lodged certificate as returned from the API' do
    before { FetchCertificate::Stub.fetch('1111-1111-1111-1111-1112') }

    let(:response) do
      get '/energy-performance-certificate/1111-1111-1111-1111-1112'
    end

    context 'with an invalid typical saving' do
      it 'displays N/A on the page' do
        expect(response.body).to include('Not applicable')
      end
    end
  end

  context 'when the assessment doesnt exist' do
    before { FetchCertificate::NoAssessmentStub.fetch('123-456') }

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
