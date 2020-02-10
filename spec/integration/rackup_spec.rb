# frozen_string_literal: true

require 'net/http'

describe 'Integration::Rackup' do
  before(:all) do
    process =
      IO.popen(
        ['rackup', '-q', '-o', '127.0.0.1', '-p', '9393', err: %i[child out]]
      )
    @process_id = process.pid

    unless process.readline.include?('port=9393')
    end
  end

  after(:all) { Process.kill('KILL', @process_id) }

  let(:request) { Net::HTTP.new('127.0.0.1', 9_393) }

  describe 'GET /find-an-assessor' do
    it 'renders the home page' do
      req = Net::HTTP::Get.new('/find-an-assessor')
      response = request.request(req)
      expect(response.code).to eq('200')
      expect(response.body).to include('Energy performance of buildings')
    end
  end

  describe 'GET /healthcheck' do
    it 'passes a healthcheck' do
      req = Net::HTTP::Get.new('/healthcheck')
      response = request.request(req)
      expect(response.code).to eq('200')
    end
  end

  describe 'GET non-existent page' do
    it 'returns custom 404 error page' do
      req = Net::HTTP::Get.new('/this-page-does-not-exist')
      response = request.request(req)
      expect(response.code).to eq('404')
      expect(response.body).to include(
        'If you typed the web address, check it is correct.'
      )
    end
  end
end
