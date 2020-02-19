# frozen_string_literal: true

require 'rspec'
require 'rack/test'
require 'webmock/rspec'
require 'epb_auth_tools'

require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/../lib/")
loader.push_dir("#{__dir__}/../spec/test_doubles/")
loader.push_dir("#{__dir__}/../spec/test_doubles/find_assessor/by_name")
loader.push_dir("#{__dir__}/../spec/test_doubles/find_assessor/by_postcode")
loader.setup

AUTH_URL = 'http://test-auth-server.gov.uk'

ENV['EPB_AUTH_CLIENT_ID'] = 'test.id'
ENV['EPB_AUTH_CLIENT_SECRET'] = 'test.client.secret'
ENV['EPB_AUTH_SERVER'] = AUTH_URL
ENV['EPB_API_URL'] = 'http://test-api.gov.uk'

module RSpecUnitMixin
  def container
    Container.new
  end
end

module RSpecFrontendServiceMixin
  include Rack::Test::Methods

  def app
    FrontendService
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus
  WebMock.disable_net_connect!(allow_localhost: true)

  config.before(:each) { OauthStub.token }
end

RSpec::Matchers.define(:redirect_to) do |path|
  match do |response|
    uri = URI.parse(response.headers['Location'])
    response.status.to_s[0] == '3' && uri.path == path
  end
end
