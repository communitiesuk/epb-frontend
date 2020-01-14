require 'rspec'
require 'rack/test'
require 'gateway/assessors_gateway'
require 'use_case/find_assessor'
require 'app'
require 'webmock/rspec'

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

def app
  FrontendService.new
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

  config.before(:each) do
    WebMock.stub_request(:post, 'http://test-auth-server.gov.uk/oauth/token')
      .to_return(
      status: 200,
      body: {
        'access_token' => 'abc', 'expires_in' => 3_600, 'token_type' => 'bearer'
      }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end
end

RSpec::Matchers.define(:redirect_to) do |path|
  match do |response|
    uri = URI.parse(response.headers['Location'])
    response.status.to_s[0] == '3' && uri.path == path
  end
end
