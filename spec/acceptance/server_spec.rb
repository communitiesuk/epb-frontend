require 'app'

describe FrontendService, 'running' do
  describe '.get /' do
    let(:response) { get '/' }

    it 'returns status 200' do
      expect(response.status).to eq(200)
    end
    it 'includes the index page title' do
      expect(response.body).to include(
        '<title>Energy performance of buildings register - Find an energy '\
        'assessor for a residential property</title>'
      )
    end
    it 'displays the index page heading' do
      expect(response.body).to include(
        'Find an energy assessor for a residential property'
      )
    end
  end

  describe '.get /healthcheck' do
    let(:response) { get '/healthcheck' }

    it 'returns status 200' do
      expect(response.status).to eq(200)
    end
  end

  describe '.get /schemes' do
    let(:response) { get '/schemes' }

    it 'displays the schemes page title' do
      expect(response.body).to include(
        'Contact an energy assessor accreditation scheme'
      )
    end
  end

  describe '.get a non-existent page' do
    let(:response) { get '/this-page-does-not-exist' }

    it 'returns status 404' do
      expect(response.status).to eq(404)
    end
  end
end
