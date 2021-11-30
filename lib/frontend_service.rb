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

  before { set_locale }

  getting_new_energy_certificate_host_name = "getting-new-energy-certificate"
  find_energy_certificate_host_name = "find-energy-certificate"

  get "/", host_name: /#{getting_new_energy_certificate_host_name}/ do
    redirect(static_start_page, 301) if static_start_page?
    @page_title =
      "#{t('find_an_assessor.top_heading')} – #{
        t('services.getting_an_energy_certificate')
      } – #{t('layout.body.govuk')}"
    @remove_back_link = true
    @allow_indexing = true

    erb :find_assessor, layout: :layout
  end

  get "/", host_name: /#{find_energy_certificate_host_name}/ do
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
        redirect localised_url("/find-an-assessor/search-by-postcode?#{query}")
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

  get "/find-an-assessor/type-of-property",
      host_name: /#{getting_new_energy_certificate_host_name}/,
      &find_an_assessor_property_type

  post "/find-an-assessor/type-of-property",
       host_name: /#{getting_new_energy_certificate_host_name}/,
       &find_an_assessor_property_type

  get "/find-a-non-domestic-certificate/search-by-postcode",
      host_name: /#{find_energy_certificate_host_name}/ do
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

        @page_title =
          "#{t('find_non_dom_certificate_by_postcode_results.top_heading')} – #{
            t('services.find_an_energy_certificate')
          } – #{t('layout.body.govuk')}"
        erb_template = :find_non_dom_certificate_by_postcode_results
        back_link "/find-a-non-domestic-certificate/search-by-postcode"
      rescue StandardError => e
        case e
        when Errors::PostcodeNotValid
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_non_dom_certificate_by_postcode.top_heading')
            } – #{t('services.find_an_energy_certificate')} – #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.postcode_error")
        when Errors::BotDetected
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_postcode.top_heading')
            } - #{t('services.find_an_energy_certificate')} - #{
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

  get "/find-a-non-domestic-certificate/search-by-reference-number",
      host_name: /#{find_energy_certificate_host_name}/ do
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
      host_name: /#{getting_new_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    erb_template = :find_assessor_by_postcode
    back_link "/find-an-assessor/type-of-property"

    response = @container.get_object(:find_assessor_by_postcode_use_case)
    @page_title =
      "#{t('find_assessor_by_postcode.top_heading')} – #{
        t('services.getting_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

    if params["postcode"]
      params["postcode"].strip!

      if valid_postcode.match(params["postcode"])
        back_link "/find-an-assessor/search-by-postcode"
        begin
          locals[:results] =
            response.execute(params["postcode"])[:data][:assessors]
          @page_title =
            "#{t('find_assessor_by_postcode_results.top_heading')} – #{
              t('services.getting_an_energy_certificate')
            } – #{t('layout.body.govuk')}"
          erb_template = :find_assessor_by_postcode_results
        rescue StandardError => e
          case e
          when Errors::PostcodeNotRegistered
            @page_title =
              "#{t('find_assessor_by_postcode_results.top_heading')} – #{
                t('services.getting_an_energy_certificate')
              } – #{t('layout.body.govuk')}"
            locals[:results] = []
            erb_template = :find_assessor_by_postcode_results
          when Errors::PostcodeNotValid
            status 400
            @page_title =
              "#{t('error.error')}#{
                t('find_assessor_by_postcode.top_heading')
              } – #{t('services.getting_an_energy_certificate')} – #{
                t('layout.body.govuk')
              }"
            @errors[:postcode] = t("validation_errors.postcode_error")
          else
            server_error(e)
          end
        end
      else
        status 400
        @page_title =
          "#{t('error.error')}#{t('find_assessor_by_postcode.top_heading')} – #{
            t('services.getting_an_energy_certificate')
          } – #{t('layout.body.govuk')}"
        @errors[:postcode] = t("validation_errors.postcode_error")
      end
    end

    show(erb_template, locals)
  end

  get "/find-an-assessor/search-by-name",
      host_name: /#{getting_new_energy_certificate_host_name}/ do
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

        @page_title =
          "#{t('find_assessor_by_name_results.top_heading')} – #{
            t('services.getting_an_energy_certificate')
          } – #{t('layout.body.govuk')}"
        erb_template = :find_assessor_by_name_results
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
      host_name: /#{getting_new_energy_certificate_host_name}/ do
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

        @page_title =
          "#{t('find_assessor_by_name_results.top_heading')} – #{
            t('services.getting_an_energy_certificate')
          } – #{t('layout.body.govuk')}"
        erb_template = :find_non_domestic_assessor_by_name_results
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

  get "/schemes" do
    @page_title = "#{t('schemes.top_heading')} - #{t('layout.body.govuk')}"
    erb :schemes, layout: :layout
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
      host_name: /#{find_energy_certificate_host_name}/,
      &find_a_certificate_property_type
  post "/find-a-certificate/type-of-property",
       host_name: /#{find_energy_certificate_host_name}/,
       &find_a_certificate_property_type

  get "/find-a-certificate/search-by-postcode",
      host_name: /#{find_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    erb_template = :find_certificate_by_postcode
    back_link "/find-a-certificate/type-of-property"

    @page_title =
      "#{t('find_certificate_by_postcode.top_heading')} - #{
        t('services.find_an_energy_certificate')
      } - #{t('layout.body.govuk')}"

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
        @page_title =
          "#{t('find_certificate_by_postcode_results.top_heading')} - #{
            t('services.find_an_energy_certificate')
          } - #{t('layout.body.govuk')}"
        erb_template = :find_certificate_by_postcode_results
        back_link "/find-a-certificate/search-by-postcode"
      rescue StandardError => e
        case e
        when Errors::PostcodeNotValid
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_postcode.top_heading')
            } - #{t('services.find_an_energy_certificate')} - #{
              t('layout.body.govuk')
            }"
          @errors[:postcode] = t("validation_errors.postcode_error")
        when Errors::BotDetected
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_postcode.top_heading')
            } - #{t('services.find_an_energy_certificate')} - #{
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
      host_name: /#{getting_new_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    erb_template = :find_non_domestic_assessor_by_postcode
    back_link "/find-an-assessor/type-of-property"

    response =
      @container.get_object(:find_non_domestic_assessor_by_postcode_use_case)

    @page_title =
      "#{t('find_non_domestic_assessor_by_postcode.top_heading')} - #{
        t('services.getting_an_energy_certificate')
      } - #{t('layout.body.govuk')}"

    if params["postcode"]
      params["postcode"].strip!

      if valid_postcode.match(params["postcode"])
        back_link "/find-a-non-domestic-assessor/search-by-postcode"
        begin
          locals[:results] =
            response.execute(params["postcode"])[:data][:assessors]

          @page_title =
            "#{
              t('find_non_domestic_assessor_by_postcode_results.top_heading')
            } - #{t('services.getting_an_energy_certificate')} - #{
              t('layout.body.govuk')
            }"
          erb_template = :find_non_domestic_assessor_by_postcode_results
        rescue StandardError => e
          case e
          when Errors::PostcodeNotRegistered
            @page_title =
              "#{t('find_non_domestic_assessor_by_postcode.top_heading')} - #{
                t('services.getting_an_energy_certificate')
              } - #{t('layout.body.govuk')}"
            locals[:results] = []
            erb_template = :find_non_domestic_assessor_by_postcode_results
          when Errors::PostcodeNotValid
            status 400
            @page_title =
              "#{t('error.error')}#{
                t('find_non_domestic_assessor_by_postcode.top_heading')
              } - #{t('services.getting_an_energy_certificate')} - #{
                t('layout.body.govuk')
              }"
            @errors[:postcode] = t("validation_errors.postcode_error")
          else
            return server_error(e)
          end
        end
      else
        status 400
        @page_title =
          "#{t('error.error')}#{
            t('find_non_domestic_assessor_by_postcode.top_heading')
          } - #{t('services.getting_an_energy_certificate')} - #{
            t('layout.body.govuk')
          }"
        @errors[:postcode] = t("validation_errors.postcode_error")
      end
    end

    show(erb_template, locals)
  end

  get "/find-a-non-domestic-certificate/search-by-street-name-and-town",
      host_name: /#{find_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    erb_template = :find_non_dom_certificate_by_street_name_and_town
    back_link "/find-a-non-domestic-certificate/search-by-postcode"

    @page_title =
      "#{t('find_non_dom_certificate_by_street_name_and_town.top_heading')} - #{
        t('services.find_an_energy_certificate')
      } - #{t('layout.body.govuk')}"

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

        @page_title =
          "#{
            t(
              'find_non_dom_certificate_by_street_name_and_town_results.top_heading',
            )
          } - #{t('services.find_an_energy_certificate')} - #{
            t('layout.body.govuk')
          }"
        erb_template = :find_non_dom_certificate_by_street_name_and_town_results
        back_link "/find-a-non-domestic-certificate/search-by-street-name-and-town"
      rescue StandardError => e
        case e
        when Errors::AllParamsMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_non_dom_certificate_by_street_name_and_town.top_heading')
            } - #{t('services.find_an_energy_certificate')} - #{
              t('layout.body.govuk')
            }"
          @errors[:street_name] = t("validation_errors.street_name_missing")
          @errors[:town] = t("validation_errors.town_missing")
        when Errors::StreetNameMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_non_dom_certificate_by_street_name_and_town.top_heading')
            } - #{t('services.find_an_energy_certificate')} - #{
              t('layout.body.govuk')
            }"
          @errors[:street_name] = t("validation_errors.street_name_missing")
        when Errors::TownMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_non_dom_certificate_by_street_name_and_town.top_heading')
            } - #{t('services.find_an_energy_certificate')} - #{
              t('layout.body.govuk')
            }"
          @errors[:town] = t("validation_errors.town_missing")
        when Errors::CertificateNotFound
          @page_title =
            "#{
              t('find_non_dom_certificate_by_street_name_and_town.top_heading')
            } - #{t('services.find_an_energy_certificate')} - #{
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
                set_subdomain_url(getting_new_energy_certificate_host_name),
              ),
          }
        else
          return server_error(e)
        end
      end
    end

    show(erb_template, locals)
  end

  get "/find-a-certificate/search-by-reference-number",
      host_name: /#{find_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    erb_template = :find_certificate_by_reference_number
    back_link "/find-a-certificate/search-by-postcode"
    @page_title =
      "#{t('find_certificate_by_reference_number.top_heading')} - #{
        t('services.find_an_energy_certificate')
      } - #{t('layout.body.govuk')}"

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
      host_name: /#{find_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    raise Error::UriTooLong if status.to_s == "414"

    erb_template = :find_certificate_by_street_name_and_town
    back_link "/find-a-certificate/search-by-postcode"

    @page_title =
      "#{t('find_certificate_by_street_name_and_town.top_heading')} - #{
        t('services.find_an_energy_certificate')
      } - #{t('layout.body.govuk')}"

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

        @page_title =
          "#{
            t('find_certificate_by_street_name_and_town_results.top_heading')
          } - #{t('services.find_an_energy_certificate')} - #{
            t('layout.body.govuk')
          }"
        erb_template = :find_certificate_by_street_name_and_town_results
        back_link "/find-a-certificate/search-by-street-name-and-town"
      rescue StandardError => e
        case e
        when Errors::AllParamsMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_street_name_and_town.top_heading')
            } - #{t('services.find_an_energy_certificate')} - #{
              t('layout.body.govuk')
            }"
          @errors[:street_name] = t("validation_errors.street_name_missing")
          @errors[:town] = t("validation_errors.town_missing")

        when Errors::UriTooLong
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_street_name_and_town.top_heading')
            } - #{t('services.find_an_energy_certificate')} - #{
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
            } - #{t('services.find_an_energy_certificate')} - #{
              t('layout.body.govuk')
            }"
          @errors[:street_name] = t("validation_errors.street_name_missing")
        when Errors::TownMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_street_name_and_town.top_heading')
            } - #{t('services.find_an_energy_certificate')} - #{
              t('layout.body.govuk')
            }"
          @errors[:town] = t("validation_errors.town_missing")
        when Errors::CertificateNotFound
          @page_title =
            "#{t('find_certificate_by_street_name_and_town.top_heading')} - #{
              t('services.find_an_energy_certificate')
            } - #{t('layout.body.govuk')}"
          @errors[:generic] = {
            error:
              "find_certificate_by_street_name_and_town.no_such_address.error",
            body:
              "find_certificate_by_street_name_and_town.no_such_address.body",
            cta: "find_certificate_by_street_name_and_town.no_such_address.cta",
            url:
              localised_url(
                set_subdomain_url(getting_new_energy_certificate_host_name),
              ),
          }

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
      " - #{t('services.find_an_energy_certificate')} - #{
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
        "#{t('dec.top_heading')}- #{
          t('services.find_an_energy_certificate')
        } - #{t('layout.body.govuk')}"
      not_found
    when Errors::AssessmentUnsupported
      @page_title =
        "#{t('dec.top_heading')}- #{
          t('services.find_an_energy_certificate')
        } - #{t('layout.body.govuk')}"
      not_found
    else
      return server_error(e)
    end
  end

  get "/accessibility-statement" do
    status 200
    @page_title =
      "#{t('accessibility_statement.top_heading')} - #{t('layout.body.govuk')}"
    erb :accessibility_statement
  end

  get "/cookies" do
    @page_title = "#{t('cookies.title')} - #{t('layout.body.govuk')}"
    status 200
    erb :cookies
  end

  post "/cookies" do
    redirect "/"
  end

  get "/service-performance" do
    @page_title = "Check how this service is performing"
    status 200
    erb_template = :service_performance
    use_case = @container.get_object(:fetch_statistics_use_case)
    data = use_case.execute
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
    erb template, layout: layout, locals: locals
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
    @page_title = "#{t('error.404.heading')} - #{t('layout.body.govuk')}"

    status 404
    erb :error_page_404 unless @errors
  end

  def server_error(exception)
    Sentry.capture_exception(exception) if defined?(Sentry)

    message =
      exception.methods.include?(:message) ? exception.message : exception

    error = { type: exception.class.name, message: message }

    if exception.methods.include? :backtrace
      error[:backtrace] = exception.backtrace
    end

    @logger.error JSON.generate(error)
    @page_title =
      "#{t('error.error')}#{t('error.500.heading')} - #{t('layout.body.govuk')}"
    status 500
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
