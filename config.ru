# frozen_string_literal: true

require 'zeitwerk'
require 'active_support/cache'
# Required by rack-attack
require 'active_support/notifications'
require 'rack/attack'
require 'sentry-ruby'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib/")
loader.setup

environment = ENV['STAGE']

unless environment == "development"
  redis_url = Helper::RedisConfigurationReader.read_configuration_url("mhclg-epb-redis-ratelimit-#{environment}")

  use Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: redis_url)
  Rack::Attack.throttle('Requests Rate Limit', limit: 100, period: 1.minutes) do |req|
    if req.forwarded_for.nil? || req.forwarded_for.empty?
      req.ip
    else
      req.forwarded_for.first
    end
  end

  Sentry.init
  use Sentry::Rack::CaptureExceptions
end

run FrontendService.new
