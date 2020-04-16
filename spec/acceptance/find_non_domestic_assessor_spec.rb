# frozen_string_literal: true

describe 'Acceptance::NonDomesticAssessor' do
  include RSpecFrontendServiceMixin

  describe '.get /find-a-non-domestic-assessor/search-by-postcode' do
    context 'when search page rendered' do
      let(:response) { get '/find-a-non-domestic-assessor/search-by-postcode' }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'displays the find a non-domestic assessor page heading' do
        expect(response.body).to include(
          'Find a non-domestic assessor to get a new EPC'
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
      let(:response) do
        get '/find-a-non-domestic-assessor/search-by-postcode?postcode='
      end

      it 'returns status 400' do
        expect(response.status).to eq(400)
      end

      it 'displays the find a non-domestic assessor page heading' do
        expect(response.body).to include(
          'Find a non-domestic assessor to get a new EPC'
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
        get '/find-a-non-domestic-assessor/search-by-postcode?postcode=NOT+A+POSTCODE'
      end

      it 'returns status 400' do
        expect(response.status).to eq(400)
      end

      it 'displays the find an assessor page heading' do
        expect(response.body).to include(
          'Find a non-domestic assessor to get a new EPC'
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
        before do
          FindAssessor::ByPostcode::Stub.search_by_postcode(
            'SW1A 2AA',
            'nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4'
          )
        end

        let(:response) do
          get '/find-a-non-domestic-assessor/search-by-postcode?postcode=SW1A+2AA'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'displays the find a non-domestic assessor page heading' do
          expect(response.body).to include('Find a non-domestic energy')
        end

        it 'has a postcode input field' do
          expect(response.body).to include(
            '<input id="postcode" name="postcode"'
          )
        end

        it 'has a search icon button' do
          expect(response.body).to include(
            '<button class="epc-search-button" data-module="govuk-button" aria-label="Find"></button>'
          )
        end

        it 'shows the assessor ID of an entry' do
          expect(response.body).to include('STROMA9999990')
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

        it 'shows qualifications of an entry' do
          expect(response.body).to include(
            'Reduced Data Standard Assessment Procedure (RdSAP)'
          )
          expect(response.body).to include(
            'Air Conditioning Simple Packaged (Level 3)'
          )
          expect(response.body).to include(
            'Air Conditioning Complexed Central (Level 4)'
          )
          expect(response.body).to include('Display Energy Certificate (DEC)')
          expect(response.body).to include(
            'Non-Domestic Energy Assessor (Level 3)'
          )
          expect(response.body).to include(
            'Non-Domestic Energy Assessor (Level 4)'
          )
        end
      end

      context 'where no assessors are near' do
        before do
          FindAssessor::ByPostcode::NoNearAssessorsStub.search_by_postcode(
            'E1 4AA',
            'nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4'
          )
        end

        let(:response) do
          get '/find-a-non-domestic-assessor/search-by-postcode?postcode=E1+4AA'
        end

        it 'returns status 200' do
          expect(response.status).to eq(200)
        end

        it 'displays the find a non-domestic assessor page heading' do
          expect(response.body).to include('Find a non-domestic energy')
        end

        it 'explains that no assessors are nearby' do
          expect(response.body).to include(
            I18n.t('find_assessor_by_postcode_results.no_assessors')
          )
        end
      end

      context 'where the postcode doesnt exist' do
        before do
          FindAssessor::ByPostcode::UnregisteredPostcodeStub.search_by_postcode(
            'B11 4FF',
            'nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4'
          )
        end

        let(:response) do
          get '/find-a-non-domestic-assessor/search-by-postcode?postcode=B11+4FF'
        end

        it 'returns status 404' do
          expect(response.status).to eq(404)
        end

        it 'displays the find a non-domestic assessor page heading' do
          expect(response.body).to include('Find a non-domestic energy')
        end

        it 'displays an error message' do
          expect(response.body).to include(
            '<span id="postcode-error" class="govuk-error-message">'
          )
          expect(response.body).to include('We could not find this postcode')
        end
      end

      context 'where the requested postcode is malformed' do
        before do
          FindAssessor::ByPostcode::InvalidPostcodeStub.search_by_postcode(
            'C11 4FF',
            'nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4'
          )
        end

        let(:response) do
          get '/find-a-non-domestic-assessor/search-by-postcode?postcode=C11+4FF'
        end

        it 'returns status 400' do
          expect(response.status).to eq(400)
        end

        it 'displays find a non-domestic assessor page heading' do
          expect(response.body).to include(
            'Find a non-domestic energy assessor'
          )
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
          FindAssessor::ByPostcode::NoNetworkStub.search_by_postcode(
            'D11 4FF',
            'nonDomesticSp3,nonDomesticCc4'
          )
        end

        let(:response) do
          get '/find-a-non-domestic-assessor/search-by-postcode?postcode=D11+4FF'
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
