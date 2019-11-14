require 'app'

describe FrontendService do
  describe 'the server having started' do
    context 'responses from /' do
      let(:response) { get '/' }

      it 'returns status 200' do
        expect(response.status).to eq(200)
        expect(response.body).to include('Energy performance of buildings')
      end
    end

    context 'responses from /healthcheck' do
      let(:response) { get '/healthcheck' }

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end
    end

    context 'responses from a 404-page' do
      let(:response) { get '/error-page' }

      it 'returns status 404' do
        expect(response.status).to eq(404)
      end
    end
  end
end
