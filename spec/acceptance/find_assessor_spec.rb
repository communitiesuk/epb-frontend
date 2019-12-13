require 'app'

describe FrontendService, "find assessor" do
  describe '.get /find-an-assessor' do
    let(:response) { get '/find-an-assessor' }

    it 'redirects to /find-an-assessor/postcode' do
      expect(response).to redirect_to '/find-an-assessor/postcode'
    end
  end
end
