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

      it 'has an input field' do
        expect(response.body).to include('<input id="query" name="query"')
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

    context 'when entering an empty query' do
      let(:response) { get '/find-a-certificate/search?query=' }

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
          '<span id="query-error" class="govuk-error-message">'
        )
        expect(response.body).to include('Enter a search term')
      end
    end

    context 'when entering an valid query' do
      context 'shows page' do
        before { FindCertificateStub.search('SW1A 2AA') }

        let(:response) { get '/find-a-certificate/search?query=SW1A+2AA' }

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
          expect(response.body).to include('123-987')
        end

        it 'shows the rating of an entry' do
          expect(response.body).to include('>B<')
        end

        it 'shows a clickable entry' do
          expect(response.body).to include(
            '<a href="/energy-performance-certificate/123-987"'
          )
        end

        it 'shows the expiry date of an entry' do
          expect(response.body).to include('01/01/2022')
        end
      end

      context 'where no certificates are present' do
        before { FindCertificateNoCertificatesStub.search('E1 4FF') }

        let(:response) { get '/find-a-certificate/search?query=E1+4FF' }

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

        let(:response) { get '/find-a-certificate/search?query=D11+4FF' }

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
