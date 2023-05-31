# frozen_string_literal: true

module Middleware
  SITE_POLICY = "accelerometer=(), autoplay=(), camera=(), cross-origin-isolated=(), display-capture=*, encrypted-media=*, fullscreen=*, geolocation=(), gyroscope=(), keyboard-map=(), magnetometer=(), microphone=(), midi=(), payment=(), picture-in-picture=(), publickey-credentials-get=(), screen-wake-lock=(), sync-xhr=(), usb=(), xr-spatial-tracking=()"

  class PermissionsPolicy
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      headers["Permissions-Policy"] = SITE_POLICY if html?(headers) || javascript?(headers)
      [status, headers, body]
    end

  private

    def html?(headers)
      return false unless (header = headers.detect { |k, _v| k.downcase == "content-type" })

      %w[text/html application/xhtml text/xml application/xml].include? header.last[%r{^\w+/\w+}]
    end

    def javascript?(headers)
      return false unless (header = headers.detect { |k, _v| k.downcase == "content-type" })

      %w[text/javascript application/javascript].include? header.last[%r{^\w+/\w+}]
    end
  end
end
