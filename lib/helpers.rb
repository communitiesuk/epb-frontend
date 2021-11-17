# frozen_string_literal: true

require "net/http"
require "epb-auth-tools"
require "csv"

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
    elsif !number.to_f.zero?
      sprintf("£%.0f", number).gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
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
      "schemes.list.#{assessor[:registeredBy][:name].split.first.downcase}.#{property}",
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

  def recommendation_header(recommendation)
    if recommendation[:improvementCode] &&
        !recommendation[:improvementCode].to_s.empty?
      OpenStruct.new(
        {
          title:
            t("improvement_code.#{recommendation[:improvementCode]}.title"),
          description:
            t(
              "improvement_code.#{recommendation[:improvementCode]}.description",
            ),
        },
      )
    else
      OpenStruct.new(
        {
          title: recommendation[:improvementTitle],
          description: recommendation[:improvementDescription],
        },
      )
    end
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

  def compact_address_without_occupier(
    address_lines,
    town,
    postcode,
    occupier
  )
    address = compact_address(address_lines, town, postcode)
    if occupier.nil? || occupier.strip.empty?
      address
    else
      address.reject { |line| line.include?(occupier) }
    end
  end

  def update_non_address_line_elements(assessment)
    non_address_line_elements = {
      "occupier_key": nil,
      "town_key": nil,
      "postcode_key": nil,
    }

    if assessment.include?(:technicalInformation) &&
        assessment[:technicalInformation].include?(:occupier)
      non_address_line_elements[:occupier_key] =
        assessment[:technicalInformation][:occupier]
    end

    if assessment.include?(:address) &&
        assessment[:address].keys.include?(:town)
      non_address_line_elements[:town_key] = ""
    end

    if assessment.include?(:address) &&
        assessment[:address].keys.include?(:postcode)
      non_address_line_elements[:postcode_key] = ""
    end
    non_address_line_elements
  end

  def find_address_lines_only(assessment)
    address_lines = [
      assessment[:address][:addressLine1],
      assessment[:address][:addressLine2],
      assessment[:address][:addressLine3],
      assessment[:address][:addressLine4],
    ]
    non_address_line_elements = update_non_address_line_elements(assessment)

    address_block =
      compact_address_without_occupier(
        address_lines,
        non_address_line_elements[:town_key],
        non_address_line_elements[:postcode_key],
        non_address_line_elements[:occupier_key],
      )

    address_block.first(2).join(", ")
  end

  def first_word_downcase(word)
    letter_array = word.split(" ")
    letter_array[0] = letter_array[0].downcase
    letter_array.join(" ")
  end

  def get_gov_header
    if request.env["HTTP_HOST"].match?(/find-energy-certificate/)
      t("services.find_an_energy_certificate")
    else
      t("services.getting_an_energy_certificate")
    end
  end

  def google_property
    request.hostname.start_with?("find") ? ENV["GTM_PROPERTY_FINDING"] : ENV["GTM_PROPERTY_GETTING"]
  end

  def static_start_page?
    !static_start_page.nil? && !static_start_page.empty?
  end

  def static_start_page
    case [request.hostname.start_with?("get"), I18n.locale == :cy]
    when [false, false]
      ENV["STATIC_START_PAGE_FINDING_EN"]
    when [false, true]
      ENV["STATIC_START_PAGE_FINDING_CY"]
    when [true, false]
      ENV["STATIC_START_PAGE_GETTING_EN"]
    when [true, true]
      ENV["STATIC_START_PAGE_GETTING_CY"]
    end
  end

  def root_page_url
    if static_start_page?
      static_start_page
    else
      "/"
    end
  end

  # Whether the REcaptchta feature is switched on and has the right environment variables set
  def using_recaptcha?
    [
      %w[EPB_RECAPTCHA_SITE_KEY EPB_RECAPTCHA_SITE_SECRET].all? { |key| ENV.key? key },
      Helper::Toggles.enabled?("use-recaptcha"),
    ].all? { |expr| expr }
  end

  def recaptcha_pass?
    return true unless using_recaptcha?

    response_token = params["g-recaptcha-response"]
    return false if response_token.nil?

    begin
      recaptcha = Net::HTTP.post_form URI("https://www.google.com/recaptcha/api/siteverify"), {
        secret: ENV["EPB_RECAPTCHA_SITE_SECRET"],
        response: response_token,
      }
      JSON.parse(recaptcha.body)["success"]
    rescue StandardError
      false
    end
  end

  def recaptcha_site_key
    ENV["EPB_RECAPTCHA_SITE_KEY"].to_s
  end

  def bot_user_agent?
    suspected_bot_user_agents.include? request.user_agent
  end

  def suspected_bot_user_agents
    JSON.parse(ENV["EPB_SUSPECTED_BOT_USER_AGENTS"])
  rescue StandardError
    []
  end

  def to_csv(view_model_array)
    return "" if view_model_array.empty?

    columns = view_model_array.first.keys.clone
    headers = columns.map { |item| item.to_s.strip }.clone
    pp columns.map

    CSV.generate do |csv|
      csv << headers
      view_model_array.each do |hash|
        csv << hash.values
      end
    end
  end
end
