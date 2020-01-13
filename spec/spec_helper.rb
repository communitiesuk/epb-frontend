require 'rspec'
require 'rack/test'
require 'gateway/assessors_gateway'
require 'stubs/oauth_stub'
require 'use_case/find_assessor'

ENV['EPB_AUTH_CLIENT_ID'] = 'test.id'
ENV['EPB_AUTH_CLIENT_SECRET'] = 'test.client.secret'
ENV['EPB_AUTH_SERVER'] = 'http://localhost:9292'
ENV['EPB_API_URL'] = 'http://example.com'

module RSpecMixin
  def app
    container = Container.new(OAuth2Stub::Client)

    described_class.new(container)
  end
end

module RSpecUnitMixin
  def container
    Container.new(OAuth2Stub::Client)
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.include Rack::Test::Methods
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus
end

RSpec::Matchers.define(:redirect_to) do |path|
  match do |response|
    uri = URI.parse(response.headers['Location'])
    response.status.to_s[0] == '3' && uri.path == path
  end
end
