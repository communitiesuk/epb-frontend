# frozen_string_literal: true

describe 'Acceptance::Assessor' do
  include RSpecFrontendServiceMixin

  describe '.get /find-an-assessor/search-by-postcode' do
    context 'when search page rendered' do
      let(:response) { get '/find-an-assessor/search-by-postcode' }

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
      let(:response) { get '/find-an-assessor/search-by-postcode?postcode=' }

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
      let(:response) do
        get '/find-an-assessor/search-by-postcode?postcode=NOT+A+POSTCODE'
      end

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
        before { FindAssessorByPostcodeStub.search_by_postcode('SW1A 2AA') }

        let(:response) do
          get '/find-an-assessor/search-by-postcode?postcode=SW1A+2AA'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'displays the find an assessor page heading' do
          expect(response.body).to include('Find an energy assessor')
        end

        it 'has a postcode input field' do
          expect(response.body).to include(
            '<input id="postcode" name="postcode"'
          )
        end

        it 'has a Find button' do
          expect(response.body).to include(
            '<button class="govuk-button" data-module="govuk-button">Find</button>'
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
      end

      context 'where no assessors are near' do
        before do
          FindAssessorByPostcodeNoNearAssessorsStub.search_by_postcode('E1 4FF')
        end

        let(:response) do
          get '/find-an-assessor/search-by-postcode?postcode=E1+4FF'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'displays the find an assessor page heading' do
          expect(response.body).to include('Find an energy assessor')
        end

        it 'explains that no assessors are nearby' do
          expect(response.body).to include(
            I18n.t('find_assessor_by_postcode_results.no_assessors')
          )
        end
      end

      context 'where the postcode doesnt exist' do
        before do
          FindAssessorByPostcodeUnregisteredPostcodeStub.search_by_postcode(
            'B11 4FF'
          )
        end

        let(:response) do
          get '/find-an-assessor/search-by-postcode?postcode=B11+4FF'
        end

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
        before do
          FindAssessorByPostcodeInvalidPostcodeStub.search_by_postcode(
            'C11 4FF'
          )
        end

        let(:response) do
          get '/find-an-assessor/search-by-postcode?postcode=C11+4FF'
        end

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

      context 'when there is no connection' do
        before do
          FindAssessorByPostcodeNoNetworkStub.search_by_postcode('D11 4FF')
        end

        let(:response) do
          get '/find-an-assessor/search-by-postcode?postcode=D11+4FF'
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

  describe '.get /find-an-assessor/search-by-name' do
    context 'when search page rendered' do
      let(:response) { get '/find-an-assessor/search-by-name' }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'displays the find an assessor page heading' do
        expect(response.body).to include('Find an energy assessor')
      end

      it 'has a postcode input field' do
        expect(response.body).to include('<input id="name" name="name"')
      end

      it 'has a Find button' do
        expect(response.body).to include(
          '<button class="govuk-button" data-module="govuk-button">Search</button>'
        )
      end

      it 'does not display an error message' do
        expect(response.body).not_to include('govuk-error-message')
      end
    end

    context 'when entering an empty name' do
      let(:response) { get '/find-an-assessor/search-by-name?name=' }

      it 'returns status 400' do
        expect(response.status).to eq(400)
      end

      it 'displays the find an assessor page heading' do
        expect(response.body).to include('Find an energy assessor')
      end

      it 'displays an error message' do
        expect(response.body).to include(
          '<span id="name-error" class="govuk-error-message">'
        )
        expect(response.body).to include('Enter a name')
      end
    end

    context 'when entering a name' do
      context 'shows page' do
        before { FindAssessorByNameStub.search_by_name('Ronald McDonald') }

        let(:response) do
          get '/find-an-assessor/search-by-name?name=Ronald%20McDonald'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'displays the find an assessor page heading' do
          expect(response.body).to include('Find an energy assessor')
        end

        it 'has a name input field' do
          expect(response.body).to include('<input id="name" name="name"')
        end

        it 'has a Search button' do
          expect(response.body).to include(
            '<button class="govuk-button" data-module="govuk-button">Search</button>'
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
      end

      context 'where no assessors have that name' do
        before do
          FindAssessorByNameNoAssessorsStub.search_by_name('Nonexistent Person')
        end

        let(:response) do
          get '/find-an-assessor/search-by-name?name=Nonexistent%20Person'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'displays the find an assessor page heading' do
          expect(response.body).to include('Find an energy assessor')
        end

        it 'explains that no assessors by that name' do
          expect(response.body).to include(
            'There are no assessors with this name.'
          )
        end
      end

      context 'when there is no connection' do
        before do
          FindAssessorByNameNoNetworkStub.search_by_name('Breaking Person')
        end

        let(:response) do
          get '/find-an-assessor/search-by-name?name=Breaking%20Person'
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
