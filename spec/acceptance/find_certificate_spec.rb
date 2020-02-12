# frozen_string_literal: true

describe 'Acceptance::Certificate' do
  include RSpecFrontendServiceMixin

  describe '.get /find-a-certificate/search' do
    context 'when search page rendered' do
      let(:response) { get '/find-a-certificate/search' }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'displays the find a certificate page heading' do
        expect(response.body).to include(
          'Find an energy performance certificate'
        )
      end

      it 'has a postcode input field' do
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
      let(:response) { get '/find-a-certificate/search?postcode=' }

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

    context 'when entering an invalid postcode' do
      let(:response) do
        get '/find-a-certificate/search?postcode=NOT+A+POSTCODE'
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
          '<span id="postcode-error" class="govuk-error-message">'
        )
        expect(response.body).to include('Enter a real postcode')
      end
    end

    context 'when entering a valid postcode' do
      context 'shows page' do
        before { FindCertificateStub.search('SW1A 2AA') }

        let(:response) { get '/find-a-certificate/search?postcode=SW1A+2AA' }

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

        it 'shows the id of an entry' do
          expect(response.body).to include('123-987')
        end

        it 'shows the rating of an entry' do
          expect(response.body).to include('>B<')
        end

        it 'shows a clickable entry' do
          expect(response.body).to include('<a href="/energy-performance-certificate/123-987"')
        end

        it 'shows the expiry date of an entry' do
          expect(response.body).to include('2022-01-01')
        end
      end

      context 'where no certificates are present' do
        before { FindCertificateNoCertificatesStub.search('E1 4FF') }

        let(:response) { get '/find-a-certificate/search?postcode=E1+4FF' }

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
            I18n.t('find_certificate_results.no_certificates')
          )
        end
      end

      context 'when there is no connection' do
        before { FindCertificateNoNetworkStub.search('D11 4FF') }

        let(:response) { get '/find-a-certificate/search?postcode=D11+4FF' }

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
