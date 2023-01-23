require "rack/protection/content_security_policy"

module Middleware
  ##
  # A custom Rack middleware that wraps the ContentSecurityPolicy middleware from the Rack::Protection module and adds
  # the additional option `report_ratio`, which takes a number of between 0 and 1. This makes the CSP policy only include
  # a report-uri directive in the given ratio of request/response cycles - i.e. a ratio of 0.1 should only send a report-uri
  # on average once every ten responses. This is in order to limit the number of reports that are sent to Sentry (as long-tail
  # cases are not of interest as they represent the CSP doing its job, and could use up Sentry quotas unnecessarily - we'd want
  # to know, though, if the CSP were blocking anything relating to the function of Google Analytics, for example, and would
  # expect these to appear in sufficiently large frequencies to be visible).
  class ContentSecurityPolicy
    def initialize(app, options = {})
      @csp_middleware = Rack::Protection::ContentSecurityPolicy.new(app, options.reject { |k, _| k == :report_ratio })
      @report_ratio = options[:report_ratio]
    end

    def call(env)
      status, headers, body = @csp_middleware.call(env)

      headers = strip_report_uri(headers.clone) unless should_report?

      [status, headers.compact, body]
    end

  private

    attr_reader :report_ratio

    def should_report?
      return true if report_ratio.nil?

      rand <= report_ratio
    end

    def strip_report_uri(headers)
      %w[
        Content-Security-Policy-Report-Only
        Content-Security-Policy
      ].each do |header|
        next unless headers.key?(header)

        headers[header] = headers[header].gsub(/;\sreport-uri\s[^\s;]+/, "")
      end
      headers
    end
  end
end
