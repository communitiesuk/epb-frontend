require 'app'

describe FrontendService, 'find assessor' do
  describe '.get /find-an-assessor' do
    let(:response) { get '/find-an-assessor' }

    it 'redirects to /find-an-assessor/postcode' do
      expect(response).to redirect_to '/find-an-assessor/postcode'
    end
  end

  describe '.get /find-an-assessor/postcode' do
    let(:response) { get '/find-an-assessor/postcode' }

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
      expect(response.body).to include('<button class="govuk-button" data-module="govuk-button">Find</button>')
    end
  end
end
