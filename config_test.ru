require File.expand_path('lib/app', File.dirname(__FILE__))
require 'webmock'
Dir['spec/test_doubles/*.rb'].each { |file| require_relative file }

WebMock.enable!

AUTH_URL = 'http://test-auth-server.gov.uk'.freeze

ENV['EPB_AUTH_CLIENT_ID'] = 'test.id'
ENV['EPB_AUTH_CLIENT_SECRET'] = 'test.client.secret'
ENV['EPB_AUTH_SERVER'] = AUTH_URL
ENV['EPB_API_URL'] = 'http://test-api.gov.uk'

run FrontendService.new
