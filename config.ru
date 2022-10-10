# frozen_string_literal: true

require "zeitwerk"
require "sentry-ruby"
require "active_support"
require "active_support/cache"
require "active_support/notifications"
require "rack/attack"
require "securerandom"

unless defined? TestLoader
  loader = Zeitwerk::Loader.new
  loader.push_dir("#{__dir__}/lib/")
  loader.setup
end

use Rack::Deflater, include: %w[text/html text/css application/javascript image/svg+xml]

use Rack::Attack
require_relative "./config/rack_attack_config"

environment = ENV["STAGE"]

if ENV['ASSETS_VERSION'].nil? && File.exist?('./ASSETS_VERSION')
  ENV['ASSETS_VERSION'] = File.read('./ASSETS_VERSION').chomp
end

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
          0.0004
        end
      else
        0.0004
      end
    end
  end
  use Sentry::Rack::CaptureExceptions
end

# setting Content-Security-Policy header (@see https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
ENV['SCRIPT_NONCE'] = SecureRandom.random_number(16**10).to_s(16).rjust(10, "0") if ENV['SCRIPT_NONCE'].nil?

csp_options = {
  script_src: "'nonce-#{ENV['SCRIPT_NONCE']}'",
  style_src: "'unsafe-inline' 'self'",
  img_src: "'self' data:",
  report_uri: Sentry.csp_report_uri,
  report_ratio: 0.01
}.delete_if { |_, value| value.nil? || value=='' }

use Middleware::ContentSecurityPolicy, **Helper::GoogleCsp.add_options_for_google_analytics(csp_options)

run FrontendService.new
