# frozen_string_literal: true

require "epb-auth-tools"

module Sinatra
  module FrontendService
    module Helpers
      def valid_postcode
        Regexp.new('^[A-Z]{1,2}\d[A-Z\d]?\s?\d[A-Z]{2}$', Regexp::IGNORECASE)
      end

      def set_subdomain_url(subdomain)
        current_url = request.url

        if settings.development?
          "http://#{subdomain}.local.gov.uk:9292"
        elsif current_url.include? "#{subdomain}-staging"
          "https://#{subdomain}-staging.digital.communities.gov.uk"
        elsif current_url.include? "#{subdomain}-integration"
          "https://#{subdomain}-integration.digital.communities.gov.uk"
        else
          "https://#{subdomain}.digital.communities.gov.uk"
        end
      end

      def number_to_currency(number)
        if number.to_f > number.to_i || number.to_f < number.to_i
          sprintf("£%.2f", number).gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
        elsif number.to_f != 0
          sprintf("£%.f", number).gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
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
            assessor[:registeredBy][:name].split.first.downcase + ".#{property}",
        )
      end

      def party_disclosure(
        code,
        string,
        code_prefix = "disclosure_code",
        certificate_prefix = "domestic_epc"
      )
        text = t(code_prefix + ".#{code}.relation")
        if text.include?("missing")
          text = string
          if text.nil?
            text =
              if code
                t(
                  certificate_prefix +
                    ".sections.information.certificate.list.disclosure_number_not_valid",
                )
              else
                t(
                  certificate_prefix +
                    ".sections.information.certificate.list.no_disclosure",
                )
              end
          end
        end

        text
      end

      def calculate_yearly_charges(assessment)
        all_charges = []
        assessment[:greenDealPlan][:charges].each do |charge|
          all_charges.append(charge[:dailyCharge].to_f)
        end
        charges = all_charges.inject(0, &:+) * 365.25
        rounded_charges = "%.2f" % charges
        rounded_charges.chomp(".00")
      end

      def localised_url(url)
        if I18n.locale != I18n.available_locales[0]
          url += (url.include?("?") ? "&" : "?")
          url += "lang=#{I18n.locale}"
        end

        url
      end

      def potential_rating_text(number)
        case number
        when 1
          t("domestic_epc.sections.recommendations.list.potential_rating_1")
        when 2
          t("domestic_epc.sections.recommendations.list.potential_rating_2")
        when 3..nil
          "#{
            t('domestic_epc.sections.recommendations.list.potential_rating_3')
          }&nbsp;#{number}"
        end
      end

      def count_certificates(certificates)
        certificates.sum { |_address_id, res| res[:certificates].size }
      end

      def date(date)
        Date.parse(date).strftime "%-d %B %Y"
      end

      def site_service_quantity(assessment, service)
        %w[One Two Three].each do |number|
          if assessment[:"siteService#{number}"][:description].include? service
            return assessment[:"siteService#{number}"][:quantity]
          end
        end

        nil
      end

      def related_assessments(assessment, type)
        output =
          assessment[:relatedAssessments].map do |related_assessment|
            related_assessment if related_assessment[:assessmentType] == type
          end

        output.compact
      end

      def address_size(address)
        address_without_address_id =
          address.tap { |key| key.delete(:addressId) }

        line_count = 0
        address_without_address_id.compact.each_value do |value|
          line_value = value.length >= 30 ? 2 : 1
          line_count += line_value
        end
        line_count >= 6 ? "govuk-body small-font" : "govuk-body"
      end
    end
  end
end
