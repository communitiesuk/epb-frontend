# frozen_string_literal: true

require "zeitwerk"
require "sentry-ruby"
require "active_support"
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

environment = ENV["STAGE"]

unless %w[development test].include? environment
  Sentry.init do |config|
    config.capture_exception_frame_locals = true
    config.environment = environment
    config.before_send = lambda do |event, hint|
      if hint[:exception].class.include?(Errors::DoNotReport)
        nil
      else
        event
      end
    end
    config.traces_sampler = lambda do |sampling_context|
      transaction_context = sampling_context[:transaction_context]

      op = transaction_context[:op]
      transaction_name = transaction_context[:name]

      case op
      when /request/
        case transaction_name
        when /images/
          0.0
        when /javascript/
          0.0
        when /css/
          0.0
        when /font/
          0.0
        else
          0.0001
        end
      else
        0.0001
      end
    end
  end
  use Sentry::Rack::CaptureExceptions
end

run FrontendService.new
