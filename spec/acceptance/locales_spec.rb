require 'app'

describe FrontendService do
  describe 'the server displaying html' do
    context 'compare the text on index' do
      let(:response) { get '/' }

      it 'does display the page title' do
        expect(response.body).to include('Find an energy assessor for a residential property')
      end
    end

    context 'compare the text on schemes' do
      let(:response) { get '/schemes' }

      it 'does display the page title' do
        expect(response.body).to include('Contact accreditation schemes for energy assessors')
      end
    end
  end
end