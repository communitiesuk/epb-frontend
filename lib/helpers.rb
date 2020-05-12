# frozen_string_literal: true

require "epb-auth-tools"

module Sinatra
  module FrontendService
    module Helpers
      def valid_postcode
        Regexp.new('^[A-Z]{1,2}\d[A-Z\d]?\s?\d[A-Z]{2}$', Regexp::IGNORECASE)
      end

      def number_to_currency(number)
        if number.to_f > number.to_i || number.to_f < number.to_i
          format("£%.2f", number).gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
        elsif number.to_f != 0
          format("£%.f", number).gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
        end
      end

      def setup_locales
        I18n.load_path = Dir[File.join(settings.root, "/../locales", "*.yml")]
        I18n.enforce_available_locales = true
        I18n.available_locales = %w[en cy]
      end

      def set_locale
        I18n.locale =
          if I18n.locale_available?(params["lang"])
            params["lang"]
          else
            I18n.default_locale
          end
      end

      def t(*args)
        I18n.t(*args)
      end

      def scheme_details(assessor, property)
        t(
          "schemes.list." +
            assessor[:registeredBy][:name].split.first.downcase +
            ".#{property}",
        )
      end

      def party_disclosure(code, string)
        text = t("disclosure_code.#{code}.relation")
        if text.include?("missing")
          text = string
          if text == nil
            text = if code
                     t("domestic_epc.sections.information.certificate.list.disclosure_number_not_valid")
                   else
                     t("domestic_epc.sections.information.certificate.list.no_disclosure")
                   end
          end
        end

        text
      end

      def localised_url(url)
        if I18n.locale != I18n.available_locales[0]
          url = url_for(url, lang: I18n.locale.to_s)
        end

        url
      end
    end
  end
end
