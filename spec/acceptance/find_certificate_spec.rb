# frozen_string_literal: true

describe 'Acceptance::Certificate' do
  include RSpecFrontendServiceMixin

  describe '.get /find-a-certificate/search-by-postcode' do
    context 'when search page rendered' do
      let(:response) { get '/find-a-certificate/search-by-postcode' }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'displays the find a certificate page heading' do
        expect(response.body).to include(
          'Find an energy performance certificate'
        )
      end

      it 'has an input field' do
        expect(response.body).to include('<input id="postcode" name="postcode"')
      end

      it 'has a Find button' do
        expect(response.body).to include(
          '<button class="govuk-button" data-module="govuk-button">Find</button>'
        )
      end

      it 'does not display an error message' do
        expect(response.body).not_to include('govuk-error-message')
      end
    end

    context 'when entering an empty postcode' do
      let(:response) { get '/find-a-certificate/search-by-postcode?postcode=' }

      it 'returns status 400' do
        expect(response.status).to eq(400)
      end

      it 'displays the find a certificate page heading' do
        expect(response.body).to include(
          'Find an energy performance certificate'
        )
      end

      it 'displays an error message' do
        expect(response.body).to include(
          '<span id="postcode-error" class="govuk-error-message">'
        )
        expect(response.body).to include('Enter a real postcode')
      end
    end

    context 'when entering an valid postcode' do
      context 'shows page' do
        before { FindCertificateStub.search_by_postcode('SW1A 2AA') }

        let(:response) do
          get '/find-a-certificate/search-by-postcode?postcode=SW1A+2AA'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'displays the find a certificate page heading' do
          expect(response.body).to include(
            'Find an energy performance certificate'
          )
        end

        it 'shows the address of an entry' do
          expect(response.body).to include('2 Marsham Street, London, SW1B 2BB')
        end

        it 'shows the report reference number of an entry' do
          expect(response.body).to include('1234-5678-9101-1121')
        end

        it 'shows the rating of an entry' do
          expect(response.body).to include('>B<')
        end

        it 'shows a clickable entry' do
          expect(response.body).to include(
            '<a href="/energy-performance-certificate/1234-5678-9101-1121"'
          )
        end

        it 'shows the expiry date of an entry' do
          expect(response.body).to include('01/01/2022')
        end
      end

      context 'where no certificates are present' do
        before { FindCertificateNoCertificatesStub.search_by_postcode('E1 4FF') }

        let(:response) do
          get '/find-a-certificate/search-by-postcode?postcode=E1+4FF'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'displays the find a certificate page heading' do
          expect(response.body).to include(
            'Find an energy performance certificate'
          )
        end

        it 'explains that no certificates are present' do
          expect(response.body).to include(
            I18n.t('find_certificate_by_postcode_results.no_certificates')
          )
        end
      end

      context 'when there is no connection' do
        before { FindCertificateNoNetworkStub.search_by_postcode('D11 4FF') }


        let(:response) do
          get '/find-a-certificate/search-by-postcode?postcode=D11+4FF'
        end

        it 'returns status 500' do
          expect(response.status).to eq(500)
        end

        it 'displays the 500 error page heading' do
          expect(response.body).to include('Network connection failed')
        end

        it 'displays error page body' do
          expect(response.body).to include('There is an internal network error')
        end
      end
    end
  end

  describe '.get /find-a-certificate/search-by-reference-number' do
    context 'when search page rendered' do
      let(:response) { get '/find-a-certificate/search-by-reference-number' }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'displays the find a certificate page heading' do
        expect(response.body).to include(
          'Find an energy performance certificate'
        )
      end

      it 'has an input field' do
        expect(response.body).to include(
          '<input id="reference_number" name="reference_number"'
        )
      end

      it 'has a Find button' do
        expect(response.body).to include(
          '<button class="govuk-button" data-module="govuk-button">Find</button>'
        )
      end

      it 'does not display an error message' do
        expect(response.body).not_to include('govuk-error-message')
      end
    end

    context 'when entering an empty postcode' do
      let(:response) do
        get '/find-a-certificate/search-by-reference-number?reference_number='
      end

      it 'returns status 400' do
        expect(response.status).to eq(400)
      end

      it 'displays the find a certificate page heading' do
        expect(response.body).to include(
          'Find an energy performance certificate'
        )
      end

      it 'displays an error message' do
        expect(response.body).to include(
          '<span id="reference-number-error" class="govuk-error-message">'
        )
        expect(response.body).to include('Enter a valid reference number')
      end
    end

    context 'when entering a valid reference number' do
      context 'shows page' do
        before { FindCertificateStub.search_by_id('1234-5678-9101-1121-3141') }

        let(:response) do
          get '/find-a-certificate/search-by-reference-number?reference_number=1234-5678-9101-1121-3141'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'displays the find a certificate page heading' do
          expect(response.body).to include(
            'Find an energy performance certificate'
          )
        end

        it 'shows the address of an entry' do
          expect(response.body).to include('2 Marsham Street, London, SW1B 2BB')
        end

        it 'shows the report reference number of an entry' do
          expect(response.body).to include('1234-5678-9101-1121-3141')
        end

        it 'shows the rating of an entry' do
          expect(response.body).to include('>B<')
        end

        it 'shows a clickable entry' do
          expect(response.body).to include(
            '<a href="/energy-performance-certificate/1234-5678-9101-1121-3141"'
          )
        end

        it 'shows the expiry date of an entry' do
          expect(response.body).to include('01/01/2019')
        end
      end

      context 'shows page' do
        before { FindCertificateStub.search_by_id('1234-5678-9101-1121-3141') }

        let(:response) do
          get '/find-a-certificate/search-by-reference-number?reference_number=12345678910111213141'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'displays the find a certificate page heading' do
          expect(response.body).to include(
            'Find an energy performance certificate'
          )
        end

        it 'shows the address of an entry' do
          expect(response.body).to include('2 Marsham Street, London, SW1B 2BB')
        end

        it 'shows the report reference number of an entry' do
          expect(response.body).to include('1234-5678-9101-1121')
        end

        it 'shows the rating of an entry' do
          expect(response.body).to include('>B<')
        end

        it 'shows a clickable entry' do
          expect(response.body).to include(
            '<a href="/energy-performance-certificate/1234-5678-9101-1121-3141"'
          )
        end

        it 'shows the expiry date of an entry' do
          expect(response.body).to include('01/01/2019')
        end
      end

      context 'where no certificates are present' do
        before do
          FindCertificateNoCertificatesStub.search_by_id('1234-5678-9101-1120')
        end

        let(:response) do
          get '/find-a-certificate/search-by-reference-number?reference_number=1234-5678-9101-1120'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'displays the find a certificate page heading' do
          expect(response.body).to include(
            'Find an energy performance certificate'
          )
        end

        it 'explains that no certificates are present' do
          expect(response.body).to include(
            'A certificate was not found with this reference number'
          )
        end
      end

      context 'when there is no connection' do
        before { FindCertificateNoNetworkStub.search_by_id('1234-5678-9101-1122') }

        let(:response) do
          get '/find-a-certificate/search-by-reference-number?reference_number=1234-5678-9101-1122'
        end

        it 'returns status 500' do
          expect(response.status).to eq(500)
        end

        it 'displays the 500 error page heading' do
          expect(response.body).to include('Network connection failed')
        end

        it 'displays error page body' do
          expect(response.body).to include('There is an internal network error')
        end
      end
    end
  end
end
