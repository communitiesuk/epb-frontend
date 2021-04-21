# frozen_string_literal: true

require "erubis"
require "i18n"
require "i18n/backend/fallbacks"
require "sinatra/base"
require_relative "container"
require_relative "helpers"

class FrontendService < Sinatra::Base
  helpers Sinatra::FrontendService::Helpers

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

    @container = Container.new
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO
  end

  before { set_locale }

  getting_new_energy_certificate_host_name = "getting-new-energy-certificate"
  find_energy_certificate_host_name = "find-energy-certificate"

  get "/", host_name: /#{getting_new_energy_certificate_host_name}/ do
    @page_title =
      "#{t('find_an_assessor.top_heading')} – #{
        t('services.getting_an_energy_certificate')
      } – #{t('layout.body.govuk')}"
    erb :find_assessor, layout: :layout
  end

  get "/", host_name: /#{find_energy_certificate_host_name}/ do
    @page_title =
      "#{t('find_a_certificate.top_heading')} – #{
        t('services.find_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

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
          property_type:
            t("find_an_assessor.property_type.errors.no_property_type_selected"),
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

    @page_title =
      "#{t('find_non_dom_certificate_by_postcode.top_heading')} – #{
        t('services.find_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

    if params["postcode"]
      params["postcode"].strip!

      begin
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
            t(
              "find_non_dom_certificate_by_reference_number.reference_number_not_valid",
            )
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

    response = @container.get_object(:find_assessor_by_postcode_use_case)
    @page_title =
      "#{t('find_assessor_by_postcode.top_heading')} – #{
        t('services.getting_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

    if params["postcode"]
      params["postcode"].strip!

      if valid_postcode.match(params["postcode"])
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
    erb_template = :find_assessor_by_name

    response = @container.get_object(:find_assessor_by_name_use_case)

    @page_title =
      "#{t('find_assessor_by_name.top_heading')} – #{
        t('services.getting_an_energy_certificate')
      } – #{t('layout.body.govuk')}"

    if params["name"]
      begin
        response = response.execute(params["name"])

        locals[:results] = response[:data][:assessors]
        locals[:meta] = response[:meta]

        @page_title =
          "#{t('find_assessor_by_name_results.top_heading')} – #{
            t('services.getting_an_energy_certificate')
          } – #{t('layout.body.govuk')}"
        erb_template = :find_assessor_by_name_results
      rescue StandardError => e
        case e
        when Errors::InvalidName
          status 400
          @page_title =
            "#{t('error.error')}#{t('find_assessor_by_name.top_heading')} – #{
              t('services.getting_an_energy_certificate')
            } – #{t('layout.body.govuk')}"
          @errors[:name] = t("find_assessor_by_name.name_error")
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
          property_type:
            t(
              "find_a_certificate.property_type.errors.no_property_type_selected",
            ),
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

    @page_title =
      "#{t('find_certificate_by_postcode.top_heading')} - #{
        t('services.find_an_energy_certificate')
      } - #{t('layout.body.govuk')}"

    if params["postcode"]
      params["postcode"].strip!

      begin
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

    response =
      @container.get_object(:find_non_domestic_assessor_by_postcode_use_case)

    @page_title =
      "#{t('find_non_domestic_assessor_by_postcode.top_heading')} - #{
        t('services.getting_an_energy_certificate')
      } - #{t('layout.body.govuk')}"

    if params["postcode"]
      params["postcode"].strip!

      if valid_postcode.match(params["postcode"])
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
          @errors[:street_name] =
            t(
              "find_non_dom_certificate_by_street_name_and_town.street_name_missing",
            )
          @errors[:town] =
            t("find_non_dom_certificate_by_street_name_and_town.town_missing")
        when Errors::StreetNameMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_non_dom_certificate_by_street_name_and_town.top_heading')
            } - #{t('services.find_an_energy_certificate')} - #{
              t('layout.body.govuk')
            }"
          @errors[:street_name] =
            t("find_certificate_by_street_name_and_town.street_name_missing")
        when Errors::TownMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_non_dom_certificate_by_street_name_and_town.top_heading')
            } - #{t('services.find_an_energy_certificate')} - #{
              t('layout.body.govuk')
            }"
          @errors[:town] =
            t("find_certificate_by_street_name_and_town.town_missing")
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
            t("find_certificate_by_reference_number.reference_number_not_valid")
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
    erb_template = :find_certificate_by_street_name_and_town

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
          @errors[:street_name] =
            t("find_certificate_by_street_name_and_town.street_name_missing")
          @errors[:town] =
            t("find_certificate_by_street_name_and_town.town_missing")
        when Errors::StreetNameMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_street_name_and_town.top_heading')
            } - #{t('services.find_an_energy_certificate')} - #{
              t('layout.body.govuk')
            }"
          @errors[:street_name] =
            t("find_certificate_by_street_name_and_town.street_name_missing")
        when Errors::TownMissing
          status 400
          @page_title =
            "#{t('error.error')}#{
              t('find_certificate_by_street_name_and_town.top_heading')
            } - #{t('services.find_an_energy_certificate')} - #{
              t('layout.body.govuk')
            }"
          @errors[:town] =
            t("find_certificate_by_street_name_and_town.town_missing")
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

    status 200
    if assessment[:data][:typeOfAssessment] == "CEPC"
      @page_title = "#{t('non_domestic_epc.top_heading')}#{@page_title}"
      show(
        :non_domestic_energy_performance_certificate,
        assessment: assessment[:data],
      )
    elsif assessment[:data][:typeOfAssessment] == "CEPC-RR"
      @page_title = "#{t('non_domestic_epc.top_heading')}#{@page_title}"
      show(
        :non_domestic_energy_performance_certificate_recommendation_report,
        assessment: assessment[:data],
      )
    elsif assessment[:data][:typeOfAssessment] == "DEC"
      @page_title = "#{t('dec.top_heading')}#{@page_title}"
      if params["print"]
        show(:printable_dec, { assessment: assessment[:data] }, :print_layout)
      else
        show(:dec, assessment: assessment[:data])
      end
    elsif assessment[:data][:typeOfAssessment] == "DEC-RR"
      @page_title =
        "#{t('dec.sections.recommendation_report.title')}#{@page_title}"
      show(:dec_recommendation_report, assessment: assessment[:data])
    elsif assessment[:data][:typeOfAssessment] == "AC-CERT"
      @page_title = "#{t('ac_cert.top_heading')}#{@page_title}"
      show(:ac_cert, assessment: assessment[:data])
    elsif assessment[:data][:typeOfAssessment] == "AC-REPORT"
      @page_title = "#{t('ac_report.top_heading')}#{@page_title}"
      show(:ac_report, assessment: assessment[:data])
    else
      @page_title = "#{t('domestic_epc.top_heading')}#{@page_title}"
      show(
        :domestic_energy_performance_certificate,
        assessment: assessment[:data],
      )
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
    attachment params[:assessment_id] + ".xml"

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

  def show(template, locals, layout = :layout)
    locals[:errors] = @errors
    erb template, layout: layout, locals: locals
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
end
