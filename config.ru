j# frozen_string_literal: true

require "zeitwerk"
require "sentry-ruby"
require "active_support/cache"
require "active_support/notifications"
require "rack/attack"

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib/")
loader.setup

use Rack::Attack
require_relative "./config/rack_attack_config"

unless %w[development test].include? ENV["STAGE"]
  Sentry.init
  use Sentry::Rack::CaptureExceptions
end

run FrontendService.new
