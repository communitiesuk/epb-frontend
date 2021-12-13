# frozen_string_literal: true

require "zeitwerk"
require "sentry-ruby"
require "active_support/cache"
require "active_support/notifications"
require "rack/attack"

unless defined? TestLoader
  loader = Zeitwerk::Loader.new
  loader.push_dir("#{__dir__}/lib/")
  loader.setup
end

use Rack::Attack
require_relative "./config/rack_attack_config"

unless %w[development test].include? ENV["STAGE"]
  Sentry.init do |config|
    config.capture_exception_frame_locals = true
    config.before_send = lambda do |event, hint|
      if hint[:exception].class.include?(Errors::DoNotReport)
        nil
      else
        event
      end
    end
  end
  use Sentry::Rack::CaptureExceptions
end

run FrontendService.new
