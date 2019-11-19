require 'app'

describe FrontendService do
  describe 'the server displaying the index page' do
    context 'compare the text' do
      let(:response) { get '/' }

      it 'does display the page title' do
        expect(response.body).to include('Find an energy assessor for a residential property')
      end
    end
  end
end