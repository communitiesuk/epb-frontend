# frozen_string_literal: true

require 'rack/attack'
require 'sentry-ruby'
require 'zeitwerk'
require 'active_support/cache'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib/")
loader.setup

environment = ENV['STAGE']
if environment == "integration"
  use Rack::Attack
  redis_url = Helper::RedisConfigurationReader.read_configuration_url("mhclg-epb-redis-ratelimit-#{environment}")
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: redis_url)

  Rack::Attack.throttle('Scrapper Limit', limit: 300, period: 1.minutes) do |req|
    if req.forwarded_for.nil? || req.forwarded_for.empty?
      req.ip
    else
      req.forwarded_for.first
    end
  end
end

unless environment == "development"
  Sentry.init
  use Sentry::Rack::CaptureExceptions
end

run FrontendService.new
