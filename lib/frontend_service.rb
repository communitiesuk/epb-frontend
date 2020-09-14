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
    @page_title = t("find_an_assessor.head.title")
    erb :find_assessor, layout: :layout
  end

  get "/", host_name: /#{find_energy_certificate_host_name}/ do
    @page_title = t("find_a_certificate.head.title")
    erb :find_certificate, layout: :layout
  end

  get "/find-an-assessor/type-of-property",
      host_name: /#{getting_new_energy_certificate_host_name}/ do
    query = params.map { |key, value| "#{key}=#{value}" }.join("&")

    if params["property_type"] == "domestic"
      redirect "/find-an-assessor/search-by-postcode?#{query}"
    elsif params["property_type"] == "non_domestic"
      redirect "/find-a-non-domestic-assessor/search-by-postcode?#{query}"
    else
      @page_title = t("find_an_assessor.head.title")
      erb :find_assessor__property_type,
          layout: :layout, locals: { lang: params[:lang] }
    end
  end

  get "/find-a-non-domestic-certificate",
      host_name: /#{find_energy_certificate_host_name}/ do
    @page_title =
      "Find an energy certificate or report for a non-domestic property"
    erb :find_non_dom_certificate, layout: :layout
  end

  get "/find-a-non-domestic-certificate/search-by-postcode",
      host_name: /#{find_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    erb_template = :find_non_dom_certificate_by_postcode

    if params["postcode"]
      params["postcode"].strip!

      @page_title = t("find_non_dom_certificate_by_postcode_results.head.title")
      begin
        erb_template = :find_non_dom_certificate_by_postcode_results

        locals[:results] =
          @container.get_object(:find_certificate_by_postcode_use_case).execute(
            params["postcode"],
            %w[CEPC DEC DEC-RR CEPC-RR],
          )[
            :data
          ][
            :assessments
          ]
      rescue StandardError => e
        case e
        when Errors::PostcodeNotValid
          status 400
          erb_template = :find_non_dom_certificate_by_postcode
          @errors[:postcode] =
            t("find_non_dom_certificate_by_postcode.postcode_not_valid")
        else
          return server_error(e)
        end
      end
    end

    @page_title = t("find_certificate_by_postcode.head.title")
    show(erb_template, locals)
  end

  get "/find-a-non-domestic-certificate/search-by-reference-number",
      host_name: /#{find_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    erb_template = :find_non_dom_certificate_by_reference_number

    if params["reference_number"]
      begin
        # If we can find the assessment then we redirect directly to it
        fetched_assessment_id =
          @container.get_object(:find_certificate_by_id_use_case).execute(
            params["reference_number"],
          )[
            :data
          ][
            :assessments
          ][
            0
          ][
            :assessmentId
          ]

        redirect "/energy-certificate/#{fetched_assessment_id}", 303
      rescue StandardError => e
        case e
        when Errors::ReferenceNumberNotValid
          status 400
          erb_template = :find_non_dom_certificate_by_reference_number
          @errors[:reference_number] =
            t(
              "find_non_dom_certificate_by_reference_number.reference_number_not_valid",
            )
        when Errors::CertificateNotFound
          erb_template = :find_non_dom_certificate_by_reference_number
          @errors[:reference_number] =
            t(
              "find_non_dom_certificate_by_reference_number.reference_number_not_registered",
            )
        else
          return server_error(e)
        end
      end
    end

    @page_title = t("find_non_dom_certificate_by_reference_number.head.title")
    show(erb_template, locals)
  end

  get "/find-an-assessor/search-by-postcode",
      host_name: /#{getting_new_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    erb_template = :find_assessor_by_postcode

    response = @container.get_object(:find_assessor_by_postcode_use_case)

    if params["postcode"]
      params["postcode"].strip!

      if valid_postcode.match(params["postcode"])
        @page_title = t("find_assessor_by_postcode_results.head.title")
        begin
          locals[:results] =
            response.execute(params["postcode"])[:data][:assessors]
          erb_template = :find_assessor_by_postcode_results
        rescue StandardError => e
          case e
          when Errors::PostcodeNotRegistered
            status 404
            @errors[:postcode] =
              t("find_assessor_by_postcode.postcode_not_registered")
          when Errors::PostcodeNotValid
            status 400
            @errors[:postcode] =
              t("find_assessor_by_postcode.postcode_not_valid")
          else
            return server_error(e)
          end
        end
      else
        status 400
        @errors[:postcode] = t("find_assessor_by_postcode.postcode_error")
      end
    end

    @page_title = t("find_assessor_by_postcode.head.title")

    show(erb_template, locals)
  end

  get "/find-an-assessor/search-by-name",
      host_name: /#{getting_new_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    erb_template = :find_assessor_by_name

    response = @container.get_object(:find_assessor_by_name_use_case)

    if params["name"]
      @page_title = t("find_assessor_by_name_results.head.title")
      begin
        erb_template = :find_assessor_by_name_results
        response = response.execute(params["name"])

        locals[:results] = response[:data][:assessors]
        locals[:meta] = response[:meta]
      rescue StandardError => e
        case e
        when Errors::InvalidName
          status 400
          erb_template = :find_assessor_by_name
          @errors[:name] = t("find_assessor_by_name.name_error")
        else
          return server_error(e)
        end
      end
    end

    @page_title = t("find_assessor_by_name.head.title")

    show(erb_template, locals)
  end

  get "/schemes" do
    @page_title = t("schemes.head.title")
    erb :schemes, layout: :layout
  end

  get "/healthcheck" do
    status 200
  end

  get "/find-a-certificate/type-of-property",
      host_name: /#{find_energy_certificate_host_name}/ do
    query = params.map { |key, value| "#{key}=#{value}" }.join("&")
    if params["property_type"] == "domestic"
      redirect "/find-a-certificate/search-by-postcode?#{query}"
    elsif params["property_type"] == "non_domestic"
      redirect "/find-a-non-domestic-certificate/search-by-postcode?#{query}"
    else
      @page_title = t("find_an_assessor.head.title")
      erb :find_certificate__property_type,
          layout: :layout, locals: { lang: params[:lang] }
    end
  end

  get "/find-a-certificate/search-by-postcode",
      host_name: /#{find_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    erb_template = :find_certificate_by_postcode

    if params["postcode"]
      params["postcode"].strip!

      @page_title = t("find_certificate_by_postcode_results.head.title")
      begin
        erb_template = :find_certificate_by_postcode_results

        locals[:results] =
          @container.get_object(:find_certificate_by_postcode_use_case).execute(
            params["postcode"],
          )[
            :data
          ][
            :assessments
          ]
      rescue StandardError => e
        case e
        when Errors::PostcodeNotValid
          status 400
          erb_template = :find_certificate_by_postcode
          @errors[:postcode] =
            t("find_certificate_by_postcode.postcode_not_valid")
        else
          return server_error(e)
        end
      end
    end

    @page_title = t("find_certificate_by_postcode.head.title")
    show(erb_template, locals)
  end

  get "/find-a-non-domestic-assessor/search-by-postcode",
      host_name: /#{getting_new_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    erb_template = :find_non_domestic_assessor_by_postcode

    response =
      @container.get_object(:find_non_domestic_assessor_by_postcode_use_case)

    if params["postcode"]
      params["postcode"].strip!

      if valid_postcode.match(params["postcode"])
        @page_title = t("find_assessor_by_postcode_results.head.title")
        begin
          locals[:results] =
            response.execute(params["postcode"])[:data][:assessors]

          erb_template = :find_non_domestic_assessor_by_postcode_results
        rescue StandardError => e
          case e
          when Errors::PostcodeNotRegistered
            status 404
            @errors[:postcode] =
              t("find_assessor_by_postcode.postcode_not_registered")
          when Errors::PostcodeNotValid
            status 400
            @errors[:postcode] =
              t("find_assessor_by_postcode.postcode_not_valid")
          else
            return server_error(e)
          end
        end
      else
        status 400
        @errors[:postcode] = t("find_assessor_by_postcode.postcode_error")
      end
    end

    @page_title = t("find_non_domestic_assessor_by_postcode.head.title")
    show(erb_template, locals)
  end

  get "/find-a-non-domestic-certificate/search-by-street-name-and-town",
      host_name: /#{find_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    erb_template = :find_non_dom_certificate_by_street_name_and_town

    if params.key?("town") || params.key?("street_name")
      @page_title =
        t("find_non_dom_certificate_by_street_name_and_town_results.head.title")
      begin
        erb_template = :find_non_dom_certificate_by_street_name_and_town_results

        locals[:results] =
          @container.get_object(
            :find_certificate_by_street_name_and_town_use_case,
          ).execute(
            params["street_name"],
            params["town"],
            %w[DEC DEC-RR CEPC CEPC-RR],
          )[
            :data
          ][
            :assessments
          ]
      rescue StandardError => e
        case e
        when Errors::AllParamsMissing
          status 400
          erb_template = :find_non_dom_certificate_by_street_name_and_town
          @errors[:street_name] =
            t(
              "find_non_dom_certificate_by_street_name_and_town.street_name_missing",
            )
          @errors[:town] =
            t("find_non_dom_certificate_by_street_name_and_town.town_missing")
        when Errors::StreetNameMissing
          status 400
          erb_template = :find_non_dom_certificate_by_street_name_and_town
          @errors[:street_name] =
            t("find_certificate_by_street_name_and_town.street_name_missing")
        when Errors::TownMissing
          status 400
          erb_template = :find_non_dom_certificate_by_street_name_and_town
          @errors[:town] =
            t("find_certificate_by_street_name_and_town.town_missing")
        when Errors::CertificateNotFound
          erb_template = :find_non_dom_certificate_by_street_name_and_town
          @errors[:generic] = {
            error:
              "find_non_dom_certificate_by_street_name_and_town.no_such_address.error",
            body:
              "find_non_dom_certificate_by_street_name_and_town.no_such_address.body",
            cta:
              "find_non_dom_certificate_by_street_name_and_town.no_such_address.cta",
            url: find_energy_certificate_url_env,
          }
        else
          return server_error(e)
        end
      end
    end

    @page_title =
      t("find_non_dom_certificate_by_street_name_and_town.head.title")
    show(erb_template, locals)
  end

  get "/find-a-certificate/search-by-reference-number",
      host_name: /#{find_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    erb_template = :find_certificate_by_reference_number

    if params["reference_number"]
      begin
        # If we can find the assessment then we redirect directly to it
        fetched_assessment_id =
          @container.get_object(:find_certificate_by_id_use_case).execute(
            params["reference_number"],
          )[
            :data
          ][
            :assessments
          ][
            0
          ][
            :assessmentId
          ]

        redirect "/energy-certificate/#{fetched_assessment_id}", 303
      rescue StandardError => e
        case e
        when Errors::ReferenceNumberNotValid
          status 400
          erb_template = :find_certificate_by_reference_number
          @errors[:reference_number] =
            t("find_certificate_by_reference_number.reference_number_not_valid")
        when Errors::CertificateNotFound
          erb_template = :find_certificate_by_reference_number
          @errors[:reference_number] =
            t(
              "find_certificate_by_reference_number.reference_number_not_registered",
            )
        else
          return server_error(e)
        end
      end
    end

    @page_title = t("find_certificate_by_reference_number.head.title")
    show(erb_template, locals)
  end

  get "/find-a-certificate/search-by-street-name-and-town",
      host_name: /#{find_energy_certificate_host_name}/ do
    @errors = {}
    locals = {}
    erb_template = :find_certificate_by_street_name_and_town

    if params.key?("town") || params.key?("street_name")
      @page_title =
        t("find_certificate_by_street_name_and_town_results.head.title")
      begin
        erb_template = :find_certificate_by_street_name_and_town_results

        locals[:results] =
          @container.get_object(
            :find_certificate_by_street_name_and_town_use_case,
          ).execute(params["street_name"], params["town"], %w[RdSAP SAP])[
            :data
          ][
            :assessments
          ]
      rescue StandardError => e
        case e
        when Errors::AllParamsMissing
          status 400
          erb_template = :find_certificate_by_street_name_and_town
          @errors[:street_name] =
            t("find_certificate_by_street_name_and_town.street_name_missing")
          @errors[:town] =
            t("find_certificate_by_street_name_and_town.town_missing")
        when Errors::StreetNameMissing
          status 400
          erb_template = :find_certificate_by_street_name_and_town
          @errors[:street_name] =
            t("find_certificate_by_street_name_and_town.street_name_missing")
        when Errors::TownMissing
          status 400
          erb_template = :find_certificate_by_street_name_and_town
          @errors[:town] =
            t("find_certificate_by_street_name_and_town.town_missing")
        when Errors::CertificateNotFound
          erb_template = :find_certificate_by_street_name_and_town
          @errors[:generic] = {
            error:
              "find_certificate_by_street_name_and_town.no_such_address.error",
            body:
              "find_certificate_by_street_name_and_town.no_such_address.body",
            cta: "find_certificate_by_street_name_and_town.no_such_address.cta",
            url: find_energy_certificate_url_env,
          }
        else
          return server_error(e)
        end
      end
    end

    @page_title = t("find_certificate_by_street_name_and_town.head.title")
    show(erb_template, locals)
  end

  get "/energy-certificate/:assessment_id" do
    use_case = @container.get_object(:fetch_certificate_use_case)
    assessment = use_case.execute(params[:assessment_id])

    status 200
    if assessment[:data][:typeOfAssessment] == "CEPC"
      show(
        :non_domestic_energy_performance_certificate,
        assessment: assessment[:data],
      )
    elsif assessment[:data][:typeOfAssessment] == "CEPC-RR"
      show(
        :non_domestic_energy_performance_certificate_recommendation_report,
        assessment: assessment[:data],
      )
    elsif assessment[:data][:typeOfAssessment] == "DEC"
      @print_title = t("dec.top_heading")
      if params["print"]
        show(:printable_dec, assessment: assessment[:data])
      else
        show(:dec, assessment: assessment[:data])
      end
    elsif assessment[:data][:typeOfAssessment] == "DEC-RR"
      show(:dec_recommendation_report, assessment: assessment[:data])
    elsif assessment[:data][:typeOfAssessment] == "AC-CERT"
      show(:ac_cert, assessment: assessment[:data])
    elsif assessment[:data][:typeOfAssessment] == "AC-REPORT"
      show(:ac_report, assessment: assessment[:data])
    else
      show(
        :domestic_energy_performance_certificate,
        assessment: assessment[:data],
      )
    end
  rescue StandardError => e
    pp e
    pp e.backtrace if e.methods.include?(:backtrace)
    case e
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
    pp e
    pp e.backtrace if e.methods.include?(:backtrace)
    case e
    when Errors::AssessmentNotFound
      not_found
    else
      return server_error(e)
    end
  end

  def show(template, locals)
    locals[:errors] = @errors
    erb template, layout: :layout, locals: locals
  end

  not_found do
    status 404
    erb :error_page_404 unless @errors
  end

  def server_error(exception)
    message =
      exception.methods.include?(:message) ? exception.message : exception

    error = { type: exception.class.name, message: message }

    if exception.methods.include? :backtrace
      error[:backtrace] = exception.backtrace
    end

    @logger.error JSON.generate(error)

    status 500
    erb :error_page_500
  end
end
