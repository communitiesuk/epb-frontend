# frozen_string_literal: true

require "rspec"
require "rack/test"
require "webmock/rspec"
require "epb-auth-tools"
require "i18n"
require "helpers"
require "nokogiri"
require "compare-xml"
require "zeitwerk"
require "capybara/rspec"
require "active_support"
require "active_support/cache"
require "active_support/notifications"
require "rack/attack"

AUTH_URL = "http://test-auth-server.gov.uk"

ENV["EPB_AUTH_CLIENT_ID"] = "test.id"
ENV["EPB_AUTH_CLIENT_SECRET"] = "test.client.secret"
ENV["EPB_AUTH_SERVER"] = AUTH_URL
ENV["EPB_API_URL"] = "http://test-api.gov.uk"
ENV["STAGE"] = "test"
ENV["EPB_UNLEASH_URI"] = "https://test-toggle-server/api"
ENV["PERMANENTLY_BANNED_IP_ADDRESSES"] = '[{"reason":"did a bad thing", "ip_address": "198.51.100.100"},{"reason":"did another bad thing", "ip_address": "198.53.120.110"}]'
ENV["WHITELISTED_IP_ADDRESSES"] = '[{"reason":"pen testers", "ip_address": "198.51.100.111"},{"reason":"pen testers", "ip_address": "198.52.101.113"}]'

I18n.load_path = Dir[File.join(File.dirname(__FILE__), "/../locales", "*.yml")]
I18n.enforce_available_locales = true
I18n.available_locales = %w[en cy]

# override the `t` helper so that it raises on missing translations when running tests
module Helpers
  def t(*args, **kwargs, &block)
    I18n.t(*args, raise: true, **kwargs, &block)
  end
end

class TestLoader
  def self.setup
    @loader = Zeitwerk::Loader.new
    @loader.push_dir("#{__dir__}/../lib/")
    @loader.push_dir("#{__dir__}/../spec/test_doubles/")
    @loader.setup
  end

  def self.override(path)
    load path
  end
end

TestLoader.setup

def loader_enable_override(name)
  TestLoader.override "overrides/#{name}.rb"
end

def loader_enable_original(lib_name)
  TestLoader.override "#{__dir__}/../lib/#{lib_name}.rb"
end

loader_enable_override "helper/toggles"

module RSpecUnitMixin
  def get_api_client
    @get_api_client ||=
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
    Rack::Builder.new do
      use Rack::Attack
      require_relative "../config/rack_attack_config"
      run FrontendService
    end
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

  config.before { OauthStub.token }
end

RSpec::Matchers.define(:redirect_to) do |path|
  match do |response|
    uri = URI.parse(response.headers["Location"])
    response.status.to_s[0] == "3" && uri.path == path
  end
end

RSpec::Matchers.define :match_html do |expected_html, **options|
  match do |actual_html|
    expected_doc = Nokogiri::HTML5.fragment(expected_html)
    actual_doc = Nokogiri::HTML5.fragment(actual_html)

    # Options documented here: https://github.com/vkononov/compare-xml
    default_options = {
      collapse_whitespace: true,
      ignore_attr_order: true,
      ignore_comments: true,
    }

    options = default_options.merge(options).merge(verbose: true)

    diff = CompareXML.equivalent?(expected_doc, actual_doc, **options)
    # account for leading spaces in class attributes as these are not significant
    diff.reject { |difference| %i[diff1 diff2].all? { |diff_ref| difference[diff_ref].include?("class") } && difference[:diff1].gsub(' "', '"') == difference[:diff2].gsub(' "', '"') }.blank?
  end
end

Capybara.default_driver = :selenium_chrome_headless
Capybara.javascript_driver = :selenium_chrome_headless
Capybara.app_host = "http://localhost:9393"
