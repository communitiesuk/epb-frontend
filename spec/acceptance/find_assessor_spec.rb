# frozen_string_literal: true

describe 'Acceptance::Assessor' do
  include RSpecFrontendServiceMixin

  describe '.get /find-an-assessor' do
    let(:response) { get '/find-an-assessor' }

    it 'redirects to /find-an-assessor/search' do
      expect(response).to redirect_to '/find-an-assessor/search'
    end
  end

  describe '.get /find-an-assessor/search' do
    context 'when search page rendered' do
      let(:response) { get '/find-an-assessor/search' }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'displays the find an assessor page heading' do
        expect(response.body).to include('Find an energy assessor')
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
      let(:response) { get '/find-an-assessor/search?postcode=' }

      it 'returns status 400' do
        expect(response.status).to eq(400)
      end

      it 'displays the find an assessor page heading' do
        expect(response.body).to include('Find an energy assessor')
      end

      it 'displays an error message' do
        expect(response.body).to include(
          '<span id="postcode-error" class="govuk-error-message">'
        )
        expect(response.body).to include('Enter a real postcode')
      end
    end

    context 'when entering an invalid postcode' do
      let(:response) { get '/find-an-assessor/search?postcode=NOT+A+POSTCODE' }

      it 'returns status 400' do
        expect(response.status).to eq(400)
      end

      it 'displays the find an assessor page heading' do
        expect(response.body).to include('Find an energy assessor')
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
        before { FindAssessorStub.search('SW1A 2AA') }

        let(:response) { get '/find-an-assessor/search?postcode=SW1A+2AA' }

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'displays the find an assessor page heading' do
          expect(response.body).to include(
            'Results for energy assessors near you'
          )
        end

        it 'shows the name of an entry' do
          expect(response.body).to include('Juan Uno')
        end

        it 'shows the email of an entry' do
          expect(response.body).to include('user@example.com')
        end

        it 'shows a clickable email' do
          expect(response.body).to include('mailto:user@example.com')
        end

        it 'shows a phone number of an entry' do
          expect(response.body).to include('07921 021 368')
        end

        it 'shows the correct distance' do
          expect(response.body).to include(
            '1.4' + ' ' +
              I18n.t('find_assessor_results.distance.miles_away_text')
          )
        end
      end

      context 'where no assessors are near' do
        before { FindAssessorsNoNearAssessorsStub.search('E1 4FF') }

        let(:response) { get '/find-an-assessor/search?postcode=E1+4FF' }

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'displays the find an assessor page heading' do
          expect(response.body).to include(
            'Results for energy assessors near you'
          )
        end

        it 'explains that no assessors are nearby' do
          expect(response.body).to include(
            I18n.t('find_assessor_results.no_assessors')
          )
        end
      end

      context 'where the postcode doesnt exist' do
        before { FindPostcodeUnregisteredPostcodeStub.search('B11 4FF') }

        let(:response) { get '/find-an-assessor/search?postcode=B11+4FF' }

        it 'returns status 404' do
          expect(response.status).to eq(404)
        end

        it 'displays the find an assessor page heading' do
          expect(response.body).to include('Find an energy assessor')
        end

        it 'displays an error message' do
          expect(response.body).to include(
            '<span id="postcode-error" class="govuk-error-message">'
          )
          expect(response.body).to include('Enter a postcode that exists')
        end
      end

      context 'where the requested postcode is malformed' do
        before { FindAssessorInvalidPostcodeStub.search('C11 4FF') }

        let(:response) { get '/find-an-assessor/search?postcode=C11+4FF' }

        it 'returns status 400' do
          expect(response.status).to eq(400)
        end

        it 'displays the find an assessor page heading' do
          expect(response.body).to include('Find an energy assessor')
        end

        it 'displays an error message' do
          expect(response.body).to include(
            '<span id="postcode-error" class="govuk-error-message">'
          )
          expect(response.body).to include(
            'Enter a postcode that is not malformed'
          )
        end
      end

      context 'where there is no scheme' do
        before { FindAssessorNoSchemeStub.search('D11 4FF') }

        let(:response) { get '/find-an-assessor/search?postcode=D11+4FF' }

        it 'returns status 500' do
          expect(response.status).to eq(500)
        end

        it 'displays the 500 error page heading' do
          expect(response.body).to include('Accreditation scheme not found')
        end

        it 'displays error page body' do
          expect(response.body).to include(
            'There is no scheme for one of the requested assessor'
          )
        end
      end
    end
  end
end
