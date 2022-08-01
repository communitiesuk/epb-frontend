module Helper
  ##
  # This module provides a method for decorating an options hash to be passed to Rack::Protection::ContentSecurityPolicy
  # in order to define a {Content Security Policy}[https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP] that works for
  # Google Tag Manager/ Google Analytics {as per Google's documentation}[https://developers.google.com/tag-platform/tag-manager/web/csp]
  # This method augments CSP options to support {Preview Mode}[https://developers.google.com/tag-platform/tag-manager/web/csp#preview_mode],
  # {GA4}[https://developers.google.com/tag-platform/tag-manager/web/csp#google_analytics_4_google_analytics] (without Google Signals) and
  # {Universal Analytics}[https://developers.google.com/tag-platform/tag-manager/web/csp#universal_analytics_google_analytics];
  # the assets here should look close to the documentation in order to help keep in sync with the documented directives.

  module GoogleCsp
    DIRECTIVES = {
      preview_mode: { # https://developers.google.com/tag-platform/tag-manager/web/csp#preview_mode
        script_src: "https://tagmanager.google.com",
        style_src: "https://tagmanager.google.com https://fonts.googleapis.com",
        img_src: "https://ssl.gstatic.com https://www.gstatic.com",
        font_src: "https://fonts.gstatic.com data:",
      },
      google_analytics_4: { # https://developers.google.com/tag-platform/tag-manager/web/csp#google_analytics_4_google_analytics
        script_src: "https://*.googletagmanager.com",
        img_src: "https://*.google-analytics.com https://*.googletagmanager.com",
        connect_src: "https://*.google-analytics.com https://*.analytics.google.com https://*.googletagmanager.com",
      },
      universal_analytics: { # https://developers.google.com/tag-platform/tag-manager/web/csp#universal_analytics_google_analytics
        script_src: "https://www.google-analytics.com https://ssl.google-analytics.com",
        img_src: "https://www.google-analytics.com",
        connect_src: "https://www.google-analytics.com",
      },
    }.freeze

    def self.add_options_for_google_analytics(base_options)
      return base_options unless ENV["GTM_PROPERTY_FINDING"] || ENV["GTM_PROPERTY_GETTING"]

      DIRECTIVES.each_value do |directive_group|
        directive_group.each do |directive, policy|
          base_options[directive] = if base_options[directive]
                                      [base_options[directive], policy].join(" ")
                                    else
                                      "'self' #{policy}" # always ensure 'self' is included first as this is inherited from the default-src directive
                                    end
        end
      end

      base_options
    end
  end
end
