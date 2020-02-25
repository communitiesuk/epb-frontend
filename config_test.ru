# frozen_string_literal: true

require 'net/http'
require 'webmock'
require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib/")
loader.setup

Dir['spec/test_doubles/**/*.rb'].each do |file|
  require_relative file
end

WebMock.enable!

OauthStub.token
FindAssessorByPostcodeStub.search_by_postcode('SW1A 2AA')
FindAssessorByNameStub.search_by_name('Supercommon Name')
FindCertificateStub.search('SW1A 2AA')
FetchAssessmentStub.fetch('1234-5678-9101-1121')
FetchAssessmentStub.fetch('2234-5678-9101-1121')

ENV['EPB_AUTH_CLIENT_ID'] = 'test.id'
ENV['EPB_AUTH_CLIENT_SECRET'] = 'test.client.secret'
ENV['EPB_AUTH_SERVER'] = 'http://test-auth-server.gov.uk'
ENV['EPB_API_URL'] = 'http://test-api.gov.uk'

run FrontendService.new
