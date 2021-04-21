# frozen_string_literal: true

require "rspec"
require "rack/test"
require "webmock/rspec"
require "epb-auth-tools"
require "helpers"
require "zeitwerk"
require "capybara/rspec"

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/../lib/")
loader.push_dir("#{__dir__}/../spec/test_doubles/")
loader.setup

AUTH_URL = "http://test-auth-server.gov.uk"

ENV["EPB_AUTH_CLIENT_ID"] = "test.id"
ENV["EPB_AUTH_CLIENT_SECRET"] = "test.client.secret"
ENV["EPB_AUTH_SERVER"] = AUTH_URL
ENV["EPB_API_URL"] = "http://test-api.gov.uk"

module RSpecUnitMixin
  def get_api_client
    @api_client ||=
      Auth::HttpClient.new ENV["EPB_AUTH_CLIENT_ID"],
                           ENV["EPB_AUTH_CLIENT_SECRET"],
                           ENV["EPB_AUTH_SERVER"],
                           ENV["EPB_API_URL"],
                           OAuth2::Client
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
  WebMock.disable_net_connect!(
    allow_localhost: true,
    allow: %w[
      find-energy-certificate.local.gov.uk
      getting-new-energy-certificate.local.gov.uk
    ],
  )

  config.before(:each) { OauthStub.token }
end

RSpec::Matchers.define(:redirect_to) do |path|
  match do |response|
    uri = URI.parse(response.headers["Location"])
    response.status.to_s[0] == "3" && uri.path == path
  end
end

Capybara.default_driver = :selenium_chrome_headless
Capybara.javascript_driver = :selenium_chrome_headless
Capybara.app_host = "http://localhost:9393"
