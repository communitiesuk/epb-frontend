# frozen_string_literal: true

require 'net/http'
require 'webmock'
require './lib/frontend_service'

Dir['spec/test_doubles/*.rb'].each do |file|
  require_relative file
end

WebMock.enable!

OauthStub.token
FindAssessorStub.search('SW1A 2AA')

ENV['EPB_AUTH_CLIENT_ID'] = 'test.id'
ENV['EPB_AUTH_CLIENT_SECRET'] = 'test.client.secret'
ENV['EPB_AUTH_SERVER'] = 'http://test-auth-server.gov.uk'
ENV['EPB_API_URL'] = 'http://test-api.gov.uk'

run FrontendService.new
