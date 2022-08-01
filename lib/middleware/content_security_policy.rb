require "rack/protection/content_security_policy"

module Middleware
  class ContentSecurityPolicy
    def initialize(app, options = {})
      @csp_middleware = Rack::Protection::ContentSecurityPolicy.new(app, options.reject { |k, _| k == :report_ratio })
      @report_ratio = options[:report_ratio]
    end

    def call(env)
      status, headers, body = @csp_middleware.call(env)

      if !Helper::Toggles.enabled?("frontend-enforce-content-security-policy") && headers.key?("Content-Security-Policy")
        headers["Content-Security-Policy-Report-Only"] = headers.delete("Content-Security-Policy")
      end

      strip_report_uri(headers) unless should_report?

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

        headers[header].gsub!(/;\sreport-uri\s[^\s;]+/, "")
      end
      headers
    end
  end
end
