# frozen_string_literal: true

require 'net/http'
require 'zeitwerk'
require 'webmock'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib/")
loader.push_dir("#{__dir__}/spec/test_doubles/")
loader.setup

WebMock.enable!

OauthStub.token
FindAssessor::ByPostcode::Stub.search_by_postcode(
  'SW1A 2AA',
  'nonDomesticSp3,nonDomesticCc4,nonDomesticDec,nonDomesticNos3,nonDomesticNos4,nonDomesticNos5'
)
FindAssessor::ByPostcode::Stub.search_by_postcode('SW1A 2AA')
FindAssessor::ByName::Stub.search_by_name('Supercommon Name')
FindAssessor::ByName::Stub.search_by_name('Somewhatcommon Name', true)
FindCertificate::Stub.search_by_postcode('SW1A 2AA')
FindCertificate::Stub.search_by_id('1234-5678-9101-1121')
FindCertificate::Stub.search_by_street_name_and_town(
  '1 Makeup Street',
  'Beauty Town'
)
FindCertificate::NoCertificatesStub.search_by_street_name_and_town(
  'Madeup Street',
  'Madeup Town'
)
FetchCertificate::Stub.fetch('1234-5678-9101-1121')
FetchCertificate::Stub.fetch('1234-5678-9101-1122', '25', 'f', true)

ENV['EPB_AUTH_CLIENT_ID'] = 'test.id'
ENV['EPB_AUTH_CLIENT_SECRET'] = 'test.client.secret'
ENV['EPB_AUTH_SERVER'] = 'http://test-auth-server.gov.uk'
ENV['EPB_API_URL'] = 'http://test-api.gov.uk'

run FrontendService.new
