# frozen_string_literal: true

require 'app'

describe FrontendService, 'find assessor' do
  describe '.get /find-an-assessor' do
    let(:response) { get '/find-an-assessor' }

    it 'redirects to /find-an-assessor/search' do
      expect(response).to redirect_to '/find-an-assessor/search'
    end
  end

  describe '.get /find-an-assessor/search' do
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

  describe '.get /find-an-assessor/search with an empty postcode param' do
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

  describe '.get /find-an-assessor/search with an invalid postcode param' do
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

  describe '.get /find-an-assessor/results' do
    let(:response) { get '/find-an-assessor/results' }

    it 'returns status 200' do
      expect(response.status).to eq(200)
    end

    it 'displays the find an assessor page heading' do
      expect(response.body).to include('Results for energy assessors near you')
    end
  end
end
