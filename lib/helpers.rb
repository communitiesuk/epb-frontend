# frozen_string_literal: true

require "epb-auth-tools"

module Sinatra
  module FrontendService
    module Helpers
      WELSH_MONTHS = {
        "January" => "Ionawr",
        "February" => "Chwefror",
        "March" => "Mawrth",
        "April" => "Ebrill",
        "May" => "Mai",
        "June" => "Mehefin",
        "July" => "Gorffennaf",
        "August" => "Awst",
        "September" => "Medi",
        "October" => "Hydref",
        "November" => "Tachwedd",
        "December" => "Rhagfyr",
      }.freeze

      DOMESTIC_CERTIFICATE_TYPES = %w[RdSAP SAP].freeze

      def valid_postcode
        Regexp.new("^[a-zA-Z0-9_ ]{4,10}$", Regexp::IGNORECASE)
      end

      def self.domestic_certificate_type?(type_of_certificate)
        DOMESTIC_CERTIFICATE_TYPES.include? type_of_certificate
      end

      def set_subdomain_url(subdomain)
        current_url = request.url

        return "http://#{subdomain}.local.gov.uk:9393" if settings.development?

        if current_url.include? "integration"
          "https://#{subdomain}-integration.digital.communities.gov.uk"
        elsif current_url.include? "staging"
          "https://#{subdomain}-staging.digital.communities.gov.uk"
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

      def remove_special_characters(input)
        input.gsub!("?", "£")
        input
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
        _certificate_prefix = "domestic_epc"
      )
        text = t(code_prefix + ".#{code}.relation")
        if text.include?("missing")
          text = string
          if text.nil? || text.strip.empty?
            text =
              if code
                t("data_missing.disclosure_number_not_valid")
              else
                t("data_missing.no_disclosure")
              end
          end
        end

        text
      end

      def calculate_yearly_charges(green_deal_plan)
        all_charges = []
        today = Date.today
        green_deal_plan[:charges].each do |charge|
          start_date = Date.parse(charge[:startDate])
          end_date = Date.parse(charge[:endDate])
          if (start_date <= today) && (end_date >= today)
            all_charges.append(charge[:dailyCharge].to_f)
          end
        end
        charges = all_charges.inject(0, &:+) * 365.25
        charges.round.to_s
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
        parsed_date =
          (date.is_a?(Date) ? date : Date.parse(date)).strftime "%-d %B %Y"

        if I18n.locale.to_s == "cy"
          WELSH_MONTHS.each do |english_month, welsh_month|
            parsed_date.gsub!(english_month, welsh_month)
          end
        end

        parsed_date
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
            unless related_assessment[:assessmentType] == type ||
                %w[RdSAP SAP].include?(
                  related_assessment[:assessmentType],
                ) && %w[RdSAP SAP].include?(type)
              next
            end

            related_assessment
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
        line_count >= 6 ? "govuk-body address-small-font" : "govuk-body"
      end

      def compact_address(address_lines, town, postcode)
        (
          address_lines + [
            (address_lines.include?(town) ? nil : town),
            postcode,
          ]
        ).compact.reject { |a| a.to_s.strip.chomp.empty? }
      end

      def get_gov_header
        sub_domain = request.env["SERVER_NAME"].split(".").first
        if sub_domain == "find-energy-certificate"
          t("services.find_an_energy_certificate")
        else
          t("services.getting_an_energy_certificate")
        end
      end
    end
  end
end
