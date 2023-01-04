# frozen_string_literal: true

require "erubis"
require "i18n"
require "i18n/backend/fallbacks"
require "sinatra/base"
require_relative "container"
require_relative "../lib/helper/toggles"

class FrontendService < Sinatra::Base
  helpers Helpers
  attr_reader :toggles

  set :erb, escape_html: true
  set :public_folder, (proc { File.join(root, "/../public") })
  if ENV["STAGE"] == "test"
    set :show_exceptions, :after_handler
  end

  Helper::Assets.setup_cache_control(self)

  configure :development do
    require "sinatra/reloader"
    register Sinatra::Reloader
    also_reload "lib/**/*.rb"
  end

  def initialize
    super
    setup_locales
    @toggles = Helper::Toggles

    @container = Container.new
    @logger = Logger.new($stdout)
    @logger.level = Logger::INFO
  end

  before do
    set_locale
    raise MaintenanceMode if request.path != "/healthcheck" && Helper::Toggles.enabled?("frontend-maintenance-mode")

    redirect(static_start_page, 303) if redirect_to_service_start_page?
  end

  GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME = "getting-new-energy-certificate"
  FIND_ENERGY_CERTIFICATE_HOST_NAME = "find-energy-certificate"

  EXCLUDE_GREEN_DEAL_REFERRER_PATHS = %w[
    /find-a-certificate/search-by-postcode
    /find-a-certificate/search-by-street-name-and-town
  ].freeze

  get "/", host_name: /#{GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME}/ do
    redirect(static_start_page, 301) if static_start_page?
    @page_title =
      "#{t('find_an_assessor.top_heading')} – #{
        t('services.getting_an_energy_certificate')
      } – #{t('layout.body.govuk')}"
    @remove_back_link = true
    @allow_indexing = true

    erb :find_assessor, layout: :layout
  end

  get "/", host_name: /#{FIND_ENERGY_CERTIFICATE_HOST_NAME}/ do
    redirect(static_start_page, 301) if static_start_page?
    @page_title =
      "#{t('find_a_certificate.top_heading')} – #{
        t('services.find_an_energy_certificate')
      } – #{t('layout.body.govuk')}"
    @remove_back_link = true
    @allow_indexing = true

    erb :find_certificate, layout: :layout
  end

  find_an_assessor_property_type =
    lambda do
      query = params.map { |key, value| "#{key}=#{value}" }.join("&")
      @errors = {}
      @page_title =
        "#{t('find_an_assessor.property_type.question_title')} – #{
          t('services.getting_an_energy_certificate')
        } – #{t('layout.body.govuk')}"
      back_link root_page_url

      if params["property_type"] == "domestic"
        redirect localised_url("/find-an-assessor/type-of-domestic-property")
      end

      if params["property_type"] == "non_domestic"
        redirect localised_url(
          "/find-a-non-domestic-assessor/search-by-postcode?#{query}",
        )
      end

      if request.post? && params["property_type"].nil?
        @errors = {
          property_type: t("validation_errors.no_property_type_selected"),
        }
        @page_title = "#{t('error.error')}#{@page_title}"
      end

      show(:find_assessor__property_type, { lang: params[:lang] })
    end

  find_an_assessor_domestic_type =
    lambda do
      query = params.map { |key, value| "#{key}=#{value}" }.join("&")
      @errors = {}
      @page_title =
        "#{t('find_an_assessor.domestic_property_type.question_title')} – #{
          t('services.getting_an_energy_certificate')
        } – #{t('layout.body.govuk')}"
      back_link "/find-an-assessor/type-of-property"

      if request.post? && params["domestic_type"].nil?
        @errors = {
          domestic_type: t("validation_errors.no_property_type_selected"),
        }
        @page_title = "#{t('error.error')}#{@page_title}"
      end

      if params["domestic_type"] && (request.referrer && !request.referrer.include?("/find-an-assessor/search-by-postcode"))
        redirect localised_url("/find-an-assessor/search-by-postcode?#{query}")
      end

      show(:find_assessor__domestic_type, { lang: params[:lang] })
    end

  get "/find-an-assessor/type-of-property",
      host_name: /#{GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME}/,
      &find_an_assessor_property_type

  post "/find-an-assessor/type-of-property",
       host_name: /#{GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME}/,
       &find_an_assessor_property_type

  get "/find-an-assessor/type-of-domestic-property",
      host_name: /#{GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME}/,
      &find_an_assessor_domestic_type

  post "/find-an-assessor/type-of-domestic-property",
       host_name: /#{GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME}/,
       &find_an_assessor_domestic_type

  get "/find-a-non-domestic-certificate/search-by-postcode",
      host_name: /#{FIND_ENERGY_CERTIFICATE_HOST_NAME}/ do
    @errors = {}
    locals = {}

    erb_template = :find_non_dom_certificate_by_postcode
    back_link "/find-a-certificate/type-of-property"

    @page_title =
      "#{t('find_non_dom_certificate_by_postcode.top_heading')} – #{
        t('services.find_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

    if params["postcode"]
      params["postcode"].strip!

      begin
        raise Errors::BotDetected if bot_user_agent? && !recaptcha_pass?

        locals[:results] =
          @container
            .get_object(:find_certificate_by_postcode_use_case)
            .execute(
              params["postcode"],
              %w[CEPC DEC DEC-RR CEPC-RR AC-CERT AC-REPORT],
            )[
            :data
          ][
            :assessments
          ]

        erb_template = :find_non_dom_certificate_by_postcode_results
        search_results_heading = locals[:results].length.positive? ? t("#{erb_template}.list", length: count_certificates(locals[:results]), postcode: CGI.escapeHTML(params["postcode"].upcase)) : t("find_certificate_by_postcode_results.no_results.no_postcode", postcode: CGI.escapeHTML(params["postcode"].upcase))
        @page_title = "#{search_results_heading} – #{t('services.find_an_energy_certificate')} – #{t('layout.body.govuk')}"
        back_link "/find-a-non-domestic-certificate/search-by-postcode"
      rescue StandardError => e
        case e
        when Errors::PostcodeIncomplete
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_postcode.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.postcode_incomplete")
        when Errors::PostcodeWrongFormat
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_postcode.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.postcode_wrong_format")
        when Errors::PostcodeNotValid
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_postcode.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.postcode_invalid")
        when Errors::BotDetected
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_postcode.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.captcha_error")
        else
          return server_error(e)
        end
      end
    end

    show(erb_template, locals)
  end

  get "/find-a-non-domestic-certificate/search-by-reference-number",
      host_name: /#{FIND_ENERGY_CERTIFICATE_HOST_NAME}/ do
    @errors = {}
    locals = {}
    erb_template = :find_non_dom_certificate_by_reference_number
    back_link "/find-a-non-domestic-certificate/search-by-postcode"
    @page_title =
      "#{t('find_non_dom_certificate_by_reference_number.top_heading')} – #{
        t('services.find_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

    if params["reference_number"]
      begin
        # If we can find the assessment then we redirect directly to it
        fetched_assessment_id =
          @container
            .get_object(:find_certificate_by_id_use_case)
            .execute(params["reference_number"])[
            :data
          ][
            :assessments
          ][
            0
          ][
            :assessmentId
          ]

        redirect localised_url("/energy-certificate/#{fetched_assessment_id}"),
                 303
      rescue StandardError => e
        case e
        when Errors::ReferenceNumberNotValid
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_non_dom_certificate_by_reference_number.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:reference_number] =
            t("validation_errors.reference_number_not_valid")
        when Errors::CertificateNotFound
          @page_title =
            "#{t('error.error')}#{
              t('find_non_dom_certificate_by_reference_number.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:reference_number] =
            t(
              "find_non_dom_certificate_by_reference_number.reference_number_not_registered",
            )
        else
          return server_error(e)
        end
      end
    end

    show(erb_template, locals)
  end

  get "/find-an-assessor/search-by-postcode",
      host_name: /#{GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME}/ do
    @errors = {}
    locals = {}
    erb_template = :find_assessor_by_postcode
    back_link "/find-an-assessor/type-of-domestic-property?domestic_type=#{params['domestic_type']}"
    qualification = params["domestic_type"] || "domesticRdSap,domesticSap"

    find_assessor_use_case = @container.get_object(:find_assessor_by_postcode_use_case)
    @page_title =
      "#{t('find_assessor_by_postcode.top_heading')} – #{
        t('services.getting_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

    if params["postcode"]
      params["postcode"].strip!

      begin
        locals[:results] =
          find_assessor_use_case.execute(params["postcode"], qualification)[:data][:assessors]
        if params["domestic_type"]
          back_link "/find-an-assessor/search-by-postcode?domestic_type=#{params['domestic_type']}"
        else
          back_link "/find-an-assessor/search-by-postcode"
        end
        erb_template = :find_assessor_by_postcode_results
        search_results_heading = locals[:results].length.positive? ? t("#{erb_template}.results", count: locals[:results].length, postcode: params["postcode"].upcase) : t("#{erb_template}.no_assessors_heading", postcode: params["postcode"].upcase)
        @page_title = "#{search_results_heading} – #{t('services.getting_an_energy_certificate')} – #{t('layout.body.govuk')}"
      rescue StandardError => e
        case e
        when Errors::PostcodeNotRegistered
          @page_title =
            "#{t('find_assessor_by_postcode_results.no_assessors_heading', postcode: params['postcode'].upcase)} – #{
                t('services.getting_an_energy_certificate')
              } – #{t('layout.body.govuk')}"
          locals[:results] = []
          erb_template = :find_assessor_by_postcode_results
        when Errors::PostcodeIncomplete
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_assessor_by_postcode.top_heading')
            } – #{t('services.getting_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.postcode_incomplete")
        when Errors::PostcodeWrongFormat
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_assessor_by_postcode.top_heading')
            } – #{t('services.getting_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.postcode_wrong_format")
        when Errors::PostcodeNotValid
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_assessor_by_postcode.top_heading')
            } – #{t('services.getting_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.postcode_invalid")
        else
          server_error(e)
        end
      end
    end

    show(erb_template, locals)
  end

  get "/find-an-assessor/search-by-name",
      host_name: /#{GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME}/ do
    @errors = {}
    locals = {}

    raise Error::UriTooLong if status.to_s == "414"

    erb_template = :find_assessor_by_name
    back_link "/find-an-assessor/search-by-postcode"

    response = @container.get_object(:find_assessor_by_name_use_case)

    @page_title =
      "#{t('find_assessor_by_name.top_heading')} – #{
        t('services.getting_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

    if params["name"]
      begin
        response = response.execute(params["name"], "domestic")

        locals[:results] = response[:data][:assessors]
        locals[:meta] = response[:meta]

        erb_template = :find_assessor_by_name_results
        search_results_heading = t((locals[:meta][:looseMatch] ? "#{erb_template}.results.results_like" : "#{erb_template}.results.results"), count: locals[:results].length, name: params["name"])
        @page_title = "#{search_results_heading} – #{t('services.getting_an_energy_certificate')} – #{t('layout.body.govuk')}"
        back_link "/find-an-assessor/search-by-name"
      rescue StandardError => e
        case e
        when Errors::InvalidName
          status 400
          @page_title =
            "#{t('error.error')}#{t('find_assessor_by_name.top_heading')} – #{
              t('services.getting_an_energy_certificate')
            } – #{t('layout.body.govuk')}"
          @errors[:name] = t("validation_errors.assessor_name_error")
        else
          return server_error(e)
        end
      end
    end

    show(erb_template, locals)
  end

  get "/find-a-non-domestic-assessor/search-by-name",
      host_name: /#{GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME}/ do
    @errors = {}
    locals = {}

    raise Error::UriTooLong if status.to_s == "414"

    erb_template = :find_non_domestic_assessor_by_name
    back_link "/find-a-non-domestic-assessor/search-by-postcode"

    response = @container.get_object(:find_assessor_by_name_use_case)

    @page_title =
      "#{t('find_assessor_by_name.top_heading')} – #{
        t('services.getting_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

    if params["name"]
      begin
        response = response.execute(params["name"], "nonDomestic")

        locals[:results] = response[:data][:assessors]
        locals[:meta] = response[:meta]

        erb_template = :find_non_domestic_assessor_by_name_results
        search_results_heading = t((locals[:meta][:looseMatch] ? "find_assessor_by_name_results.results.results_like" : "find_assessor_by_name_results.results.results"), count: locals[:results].length, name: params["name"])
        @page_title = "#{search_results_heading} – #{t('services.getting_an_energy_certificate')} – #{t('layout.body.govuk')}"
        back_link "/find-a-non-domestic-assessor/search-by-name"
      rescue StandardError => e
        case e
        when Errors::InvalidName
          status 400
          @page_title =
            "#{t('error.error')}#{t('find_assessor_by_name.top_heading')} – #{
              t('services.getting_an_energy_certificate')
            } – #{t('layout.body.govuk')}"
          @errors[:name] = t("validation_errors.assessor_name_error")
        else
          return server_error(e)
        end
      end
    end

    show(erb_template, locals)
  end

  get "/healthcheck" do
    status 200
  end

  find_a_certificate_property_type =
    lambda do
      query = params.map { |key, value| "#{key}=#{value}" }.join("&")
      @errors = {}
      @page_title =
        "#{t('find_a_certificate.property_type.question_title')} – #{
          t('services.find_an_energy_certificate')
        } – #{t('layout.body.govuk')}"
      back_link root_page_url

      if params["property_type"] == "domestic"
        redirect localised_url(
          "/find-a-certificate/search-by-postcode?#{query}",
        )
      end

      if params["property_type"] == "non_domestic"
        redirect localised_url(
          "/find-a-non-domestic-certificate/search-by-postcode?#{query}",
        )
      end

      if request.post? && params["property_type"].nil?
        @errors = {
          property_type: t("validation_errors.no_property_type_selected"),
        }

        @page_title = "#{t('error.error')}#{@page_title}"
      end

      show(:find_certificate__property_type, { lang: params[:lang] })
    end

  get "/find-a-certificate/type-of-property",
      host_name: /#{FIND_ENERGY_CERTIFICATE_HOST_NAME}/,
      &find_a_certificate_property_type
  post "/find-a-certificate/type-of-property",
       host_name: /#{FIND_ENERGY_CERTIFICATE_HOST_NAME}/,
       &find_a_certificate_property_type

  get "/find-a-certificate/search-by-postcode",
      host_name: /#{FIND_ENERGY_CERTIFICATE_HOST_NAME}/ do
    @errors = {}
    locals = {}
    erb_template = :find_certificate_by_postcode
    back_link "/find-a-certificate/type-of-property"

    @page_title =
      "#{t('find_certificate_by_postcode.top_heading')} – #{
        t('services.find_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

    if params["postcode"]
      params["postcode"].strip!

      begin
        raise Errors::BotDetected if bot_user_agent? && !recaptcha_pass?

        locals[:results] =
          @container
            .get_object(:find_certificate_by_postcode_use_case)
            .execute(params["postcode"])[
            :data
          ][
            :assessments
          ]
        erb_template = :find_certificate_by_postcode_results
        search_results_heading = locals[:results].size.positive? ? t("#{erb_template}.list", count: count_certificates(locals[:results]), postcode: CGI.escapeHTML(params["postcode"].upcase)) : t("#{erb_template}.no_results.no_postcode", postcode: CGI.escapeHTML(params["postcode"].upcase))
        @page_title = "#{search_results_heading} – #{t('services.find_an_energy_certificate')} – #{t('layout.body.govuk')}"
        back_link "/find-a-certificate/search-by-postcode"
      rescue StandardError => e
        case e
        when Errors::PostcodeIncomplete
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_postcode.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.postcode_incomplete")
        when Errors::PostcodeWrongFormat
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_postcode.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.postcode_wrong_format")
        when Errors::PostcodeNotValid
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_postcode.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.postcode_invalid")
        when Errors::BotDetected
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_postcode.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = "Please verify that you’re a human and try again."
        else
          return server_error(e)
        end
      end
    end

    show(erb_template, locals)
  end

  get "/find-a-non-domestic-assessor/search-by-postcode",
      host_name: /#{GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME}/ do
    @errors = {}
    locals = {}
    erb_template = :find_non_domestic_assessor_by_postcode
    back_link "/find-an-assessor/type-of-property"

    response =
      @container.get_object(:find_non_domestic_assessor_by_postcode_use_case)

    @page_title =
      "#{t('find_non_domestic_assessor_by_postcode.top_heading')} – #{
        t('services.getting_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

    if params["postcode"]
      params["postcode"].strip!

      begin
        locals[:results] =
          response.execute(params["postcode"])[:data][:assessors]
        back_link "/find-a-non-domestic-assessor/search-by-postcode"

        erb_template = :find_non_domestic_assessor_by_postcode_results
        search_results_heading = locals[:results].length.positive? ? t("find_assessor_by_postcode_results.results", count: locals[:results].length, postcode: params["postcode"].upcase) : t("find_assessor_by_postcode_results.no_assessors_heading", postcode: params["postcode"].upcase)
        @page_title = "#{search_results_heading} – #{t('services.getting_an_energy_certificate')} – #{t('layout.body.govuk')}"
      rescue StandardError => e
        case e
        when Errors::PostcodeNotRegistered
          @page_title =
            "#{t('find_assessor_by_postcode_results.no_assessors_heading', postcode: params['postcode'].upcase)} – #{
              t('services.getting_an_energy_certificate')
            } – #{t('layout.body.govuk')}"
          locals[:results] = []
          erb_template = :find_non_domestic_assessor_by_postcode_results
        when Errors::PostcodeIncomplete
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_non_domestic_assessor_by_postcode.top_heading')
            } – #{t('services.getting_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.postcode_incomplete")
        when Errors::PostcodeWrongFormat
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_non_domestic_assessor_by_postcode.top_heading')
            } – #{t('services.getting_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.postcode_wrong_format")
        when Errors::PostcodeNotValid
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_non_domestic_assessor_by_postcode.top_heading')
            } – #{t('services.getting_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.postcode_invalid")
        else
          return server_error(e)
        end
      end
    end

    show(erb_template, locals)
  end

  get "/find-a-non-domestic-certificate/search-by-street-name-and-town",
      host_name: /#{FIND_ENERGY_CERTIFICATE_HOST_NAME}/ do
    @errors = {}
    locals = {}
    erb_template = :find_non_dom_certificate_by_street_name_and_town
    back_link "/find-a-non-domestic-certificate/search-by-postcode"

    @page_title =
      "#{t('find_non_dom_certificate_by_street_name_and_town.top_heading')} – #{
        t('services.find_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

    if params.key?("town") || params.key?("street_name")
      begin
        locals[:results] =
          @container
            .get_object(:find_certificate_by_street_name_and_town_use_case)
            .execute(
              params["street_name"],
              params["town"],
              %w[AC-CERT AC-REPORT DEC DEC-RR CEPC CEPC-RR],
            )[
            :data
          ][
            :assessments
          ]

        erb_template = :find_non_dom_certificate_by_street_name_and_town_results
        @page_title = "#{t("#{erb_template}.list", length: count_certificates(locals[:results]), query: "#{params['street_name']} #{params['town']}")} – #{t('services.find_an_energy_certificate')} – #{t('layout.body.govuk')}"
        back_link "/find-a-non-domestic-certificate/search-by-street-name-and-town"
      rescue StandardError => e
        case e
        when Errors::AllParamsMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_non_dom_certificate_by_street_name_and_town.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:street_name] = t("validation_errors.street_name_missing")
          @errors[:town] = t("validation_errors.town_missing")
        when Errors::StreetNameMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_non_dom_certificate_by_street_name_and_town.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:street_name] = t("validation_errors.street_name_missing")
        when Errors::TownMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_non_dom_certificate_by_street_name_and_town.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:town] = t("validation_errors.town_missing")
        when Errors::CertificateNotFound
          @page_title =
            "#{
              t('find_non_dom_certificate_by_street_name_and_town.no_such_address.error').chomp('.')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:generic] = {
            error:
              "find_non_dom_certificate_by_street_name_and_town.no_such_address.error",
            body:
              "find_non_dom_certificate_by_street_name_and_town.no_such_address.body",
            cta:
              "find_non_dom_certificate_by_street_name_and_town.no_such_address.cta",
            url:
              localised_url(
                set_subdomain_url(GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME),
              ),
          }
        when Errors::RequestTimeoutError
          status 504
          erb_template = :search_by_street_name_and_town__timeout
          locals[:search_by_postcode_url] = "/find-a-non-domestic-certificate/search-by-postcode"
        else
          return server_error(e)
        end
      end
    end

    show(erb_template, locals)
  end

  get "/find-a-certificate/search-by-reference-number",
      host_name: /#{FIND_ENERGY_CERTIFICATE_HOST_NAME}/ do
    @errors = {}
    locals = {}
    erb_template = :find_certificate_by_reference_number
    back_link "/find-a-certificate/search-by-postcode"
    @page_title =
      "#{t('find_certificate_by_reference_number.top_heading')} – #{
        t('services.find_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

    if params["reference_number"]
      begin
        # If we can find the assessment then we redirect directly to it
        fetched_assessment_id =
          @container
            .get_object(:find_certificate_by_id_use_case)
            .execute(params["reference_number"])[
            :data
          ][
            :assessments
          ][
            0
          ][
            :assessmentId
          ]
        redirect localised_url("/energy-certificate/#{fetched_assessment_id}"),
                 303
      rescue StandardError => e
        @page_title = "#{t('error.error')}#{@page_title}"
        case e
        when Errors::ReferenceNumberNotValid
          status 400
          @errors[:reference_number] =
            t("validation_errors.reference_number_not_valid")
        when Errors::CertificateNotFound
          @errors[:reference_number] =
            t(
              "find_certificate_by_reference_number.reference_number_not_registered",
            )
        else
          return server_error(e)
        end
      end
    end

    show(erb_template, locals)
  end

  get "/find-a-certificate/search-by-street-name-and-town",
      host_name: /#{FIND_ENERGY_CERTIFICATE_HOST_NAME}/ do
    @errors = {}
    locals = {}
    raise Error::UriTooLong if status.to_s == "414"

    erb_template = :find_certificate_by_street_name_and_town
    back_link "/find-a-certificate/search-by-postcode"

    @page_title =
      "#{t('find_certificate_by_street_name_and_town.top_heading')} – #{
        t('services.find_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

    if params.key?("town") || params.key?("street_name")
      begin
        locals[:results] =
          @container
            .get_object(:find_certificate_by_street_name_and_town_use_case)
            .execute(params["street_name"], params["town"], %w[RdSAP SAP])[
            :data
          ][
            :assessments
          ]

        erb_template = :find_certificate_by_street_name_and_town_results
        number_of_results = count_certificates(locals[:results])
        result_content = number_of_results == 1 ? "list.one_result" : "list.more_than_one_result"
        @page_title = "#{t("#{erb_template}.#{result_content}", length: number_of_results, query: "#{params['street_name']} #{params['town']}")} – #{t('services.find_an_energy_certificate')} – #{t('layout.body.govuk')}"
        back_link "/find-a-certificate/search-by-street-name-and-town"
      rescue StandardError => e
        case e
        when Errors::AllParamsMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_street_name_and_town.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:street_name] = t("validation_errors.street_name_missing")
          @errors[:town] = t("validation_errors.town_missing")

        when Errors::UriTooLong
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_street_name_and_town.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          if params["street_name"].length > 2042
            @errors[:street_name] = t("validation_errors.street_name_missing")
          end

        when Errors::StreetNameMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_street_name_and_town.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:street_name] = t("validation_errors.street_name_missing")
        when Errors::TownMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_street_name_and_town.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:town] = t("validation_errors.town_missing")
        when Errors::CertificateNotFound
          @page_title =
            "#{t('find_certificate_by_street_name_and_town.no_such_address.error').chomp('.')} – #{
              t('services.find_an_energy_certificate')
            } – #{t('layout.body.govuk')}"
          @errors[:generic] = {
            error:
              "find_certificate_by_street_name_and_town.no_such_address.error",
            body:
              "find_certificate_by_street_name_and_town.no_such_address.body",
            cta: "find_certificate_by_street_name_and_town.no_such_address.cta",
            url:
              localised_url(
                set_subdomain_url(GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME),
              ),
          }
        when Errors::RequestTimeoutError
          status 504
          erb_template = :search_by_street_name_and_town__timeout
          locals[:search_by_postcode_url] = "/find-a-certificate/search-by-postcode"
        else
          return server_error(e)
        end
      end
    end

    show(erb_template, locals)
  end

  get "/energy-certificate/:assessment_id" do
    use_case = @container.get_object(:fetch_certificate_use_case)
    assessment = use_case.execute(params[:assessment_id])
    @page_title =
      " – #{t('services.find_an_energy_certificate')} – #{
        t('layout.body.govuk')
      }"
    use_print_view = params["print"] == "true"
    back_link request.referrer ? assessment_back_link(assessment) : nil

    cache_control :public, max_age: 60
    status 200

    case assessment[:data][:typeOfAssessment]
    when "CEPC"
      @page_title = "#{t('non_domestic_epc.top_heading')}#{@page_title}"
      show_with_print_option :non_domestic_energy_performance_certificate,
                             { assessment: assessment[:data] },
                             use_print_view
    when "CEPC-RR"
      @page_title = "#{t('non_domestic_epc.top_heading')}#{@page_title}"
      show_with_print_option :non_domestic_energy_performance_certificate_recommendation_report,
                             { assessment: assessment[:data] },
                             use_print_view
    when "DEC"
      @page_title = "#{t('dec.top_heading')}#{@page_title}"
      template = use_print_view ? :printable_dec : :dec
      show_with_print_option template,
                             { assessment: assessment[:data] },
                             use_print_view,
                             skip_custom_css: true
    when "DEC-RR"
      @page_title =
        "#{t('dec.sections.recommendation_report.title')}#{@page_title}"
      show_with_print_option :dec_recommendation_report,
                             { assessment: assessment[:data] },
                             use_print_view
    when "AC-CERT"
      @page_title = "#{t('ac_cert.top_heading')}#{@page_title}"
      show_with_print_option :ac_cert,
                             { assessment: assessment[:data] },
                             use_print_view
    when "AC-REPORT"
      @page_title = "#{t('ac_report.top_heading')}#{@page_title}"
      show_with_print_option :ac_report,
                             { assessment: assessment[:data] },
                             use_print_view
    else
      @page_title = "#{t('domestic_epc.top_heading')}#{@page_title}"
      @exclude_green_deal_referrer_paths = EXCLUDE_GREEN_DEAL_REFERRER_PATHS
      show_with_print_option :domestic_energy_performance_certificate,
                             { assessment: assessment[:data] },
                             use_print_view
    end
  rescue StandardError => e
    case e
    when Errors::AssessmentGone
      @page_title = "#{t('error.410.heading')} – #{t('layout.body.govuk')}"
      status 410
      erb :error_page_410 unless @errors
    when Errors::AssessmentNotFound
      not_found
    else
      return server_error(e)
    end
  end

  get "/energy-certificate/:assessment_id/dec_summary" do
    use_case = @container.get_object(:fetch_dec_summary_use_case)
    assessment = use_case.execute(params[:assessment_id])
    status 200

    content_type "application/xml"
    attachment "#{params[:assessment_id]}.xml"

    assessment[:data]
  rescue StandardError => e
    case e
    when Errors::AssessmentNotFound
      @page_title =
        "#{t('dec.top_heading')} – #{
          t('services.find_an_energy_certificate')
        } – #{t('layout.body.govuk')}"
      not_found
    when Errors::AssessmentUnsupported
      @page_title =
        "#{t('dec.top_heading')} – #{
          t('services.find_an_energy_certificate')
        } – #{t('layout.body.govuk')}"
      not_found
    else
      return server_error(e)
    end
  end

  get "/accessibility-statement" do
    status 200
    @page_title =
      "#{t('accessibility_statement.top_heading')} – #{t('layout.body.govuk')}"
    back_link false
    erb :accessibility_statement
  end

  get "/cookies" do
    @page_title = "#{t('cookies.title')} – #{t('layout.body.govuk')}"
    back_link false
    status 200
    erb :cookies, locals: { is_success: params[:success] == "true" }
  end

  post "/cookies" do
    redirect localised_url("/cookies?success=true")
  end

  get "/service-performance" do
    @page_title = "#{t('service_performance.heading')} – #{t('layout.body.govuk')}"
    status 200
    back_link false
    erb_template = :service_performance
    use_case = @container.get_object(:fetch_statistics_use_case)
    data = use_case.execute
    if Helper::Toggles.enabled?("frontend-interesting-numbers")
      interesting_numbers_use_case = @container.get_object(:fetch_interesting_numbers_use_case)
      heatpump_data = interesting_numbers_use_case.execute("heat_pump_count_for_sap")
      data[:heatpump_data] = heatpump_data
    end
    show(erb_template, data)

  rescue Errors::ReportIncomplete
    data[:heatpump_data] = nil
    show(erb_template, data)

  rescue StandardError => e
    return server_error(e)
  end

  get "/service-performance/download-csv" do
    use_case = @container.get_object(:fetch_statistics_csv_use_case)
    data = use_case.execute(params["country"])

    content_type "application/csv"
    attachment params["country"] ? "service-performance-#{params['country']}.csv" : "service-performance-all-regions.csv"

    to_csv(data)

  rescue StandardError => e
    content_type "text/html"
    return server_error(e)
  end

  def show(template, locals, layout = :layout)
    locals[:errors] = @errors
    erb template, layout:, locals:
  end

  def show_with_print_option(
    template,
    locals,
    is_print_view,
    skip_custom_css: false
  )
    @skip_custom_css = true if skip_custom_css
    show(
      template,
      locals.merge({ print_view: is_print_view }),
      is_print_view ? :print_layout : :layout,
    )
  end

  not_found do
    @page_title = "#{t('error.404.heading')} – #{t('layout.body.govuk')}"

    status 404
    erb :error_page_404 unless @errors
  end

  class MaintenanceMode < RuntimeError
    include Errors::DoNotReport
  end

  error MaintenanceMode do
    status 503
    @remove_back_link = true
    @page_title =
      "#{t('service_unavailable.title')} – #{t('layout.body.govuk')}"
    erb :service_unavailable
  end

  def server_error(exception)
    was_timeout = exception.is_a?(Errors::RequestTimeoutError)
    Sentry.capture_exception(exception) if defined?(Sentry) && !was_timeout

    message =
      exception.methods.include?(:message) ? exception.message : exception

    error = { type: exception.class.name, message: }

    if exception.methods.include? :backtrace
      error[:backtrace] = exception.backtrace
    end

    @logger.error JSON.generate(error)
    @page_title =
      "#{t('error.500.heading')} – #{t('layout.body.govuk')}"
    status(was_timeout ? 504 : 500)
    erb :error_page_500
  end

  def back_link(url)
    if url
      @back_url = url
    else
      @remove_back_link = true
    end
  end

  def assessment_back_link(assessment)
    type_fragment = %w[RdSAP SAP].include?(assessment[:data][:typeOfAssessment]) ? "find-a-certificate" : "find-a-non-domestic-certificate"
    postcode = assessment.dig(:data, :address, :postcode)

    "/#{type_fragment}/search-by-postcode?postcode=#{CGI.escape(postcode)}"
  end
end
