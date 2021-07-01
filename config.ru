# frozen_string_literal: true

require 'rack/attack'
require 'sentry-ruby'
require 'zeitwerk'
require 'active_support/cache'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib/")
loader.setup

environment = ENV['STAGE']
  use Rack::Attack
  redis_url = Helper::RedisConfigurationReader.read_configuration_url("mhclg-epb-redis-ratelimit-#{environment}")
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(url: redis_url)

Sentry.init
use Sentry::Rack::CaptureExceptions

run FrontendService.new
