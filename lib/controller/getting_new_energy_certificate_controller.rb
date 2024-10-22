module Controller
  class GettingNewEnergyCertificateController < Controller::BaseController
    GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME = "getting-new-energy-certificate"
    FIND_ENERGY_CERTIFICATE_HOST_NAME = "find-energy-certificate"

    find_an_assessor_property_type =
      lambda do
        query = params.map { |key, value| "#{key}=#{value}" }.join("&")
        @errors = {}
        @page_title =
          "#{t('find_an_assessor.property_type.question_title')} – #{
            t('services.getting_an_energy_certificate')
          } – #{t('layout.body.govuk')}"

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

    get "/", host_name: /#{GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME}/ do
      redirect(static_start_page, 301) if static_start_page?
      @page_title =
        "#{t('find_an_assessor.top_heading')} – #{
          t('services.getting_an_energy_certificate')
        } – #{t('layout.body.govuk')}"

      erb :find_assessor, layout: :layout
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

    get "/find-an-assessor/search-by-postcode",
        host_name: /#{GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME}/ do
      @errors = {}
      locals = {}
      erb_template = :find_assessor_by_postcode
      qualification = params["domestic_type"] || "domesticRdSap,domesticSap"

      find_assessor_use_case = @container.get_object(:find_assessor_by_postcode_use_case)
      @page_title =
        "#{t('find_assessor_by_postcode.top_heading')} – #{
          t('services.getting_an_energy_certificate')
        } – #{t('layout.body.govuk')}"

      if params["postcode"]

        begin
          raise Errors::PostcodeWrongFormat if params["postcode"].is_a?(Array)

          params["postcode"].strip!
          locals[:results] =
            find_assessor_use_case.execute(params["postcode"], qualification)[:data][:assessors]
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

      response = @container.get_object(:find_assessor_by_name_use_case)

      @page_title =
        "#{t('find_assessor_by_name.top_heading')} – #{
          t('services.getting_an_energy_certificate')
        } – #{t('layout.body.govuk')}"

      if params["name"]
        begin
          raise Errors::InvalidName if params["name"].is_a?(Array)

          response = response.execute(params["name"], "domestic")

          locals[:results] = response[:data][:assessors]
          locals[:meta] = response[:meta]

          erb_template = :find_assessor_by_name_results
          search_results_heading = t((locals[:meta][:looseMatch] ? "#{erb_template}.results.results_like" : "#{erb_template}.results.results"), count: locals[:results].length, name: params["name"])
          @page_title = "#{search_results_heading} – #{t('services.getting_an_energy_certificate')} – #{t('layout.body.govuk')}"
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

      response = @container.get_object(:find_assessor_by_name_use_case)

      @page_title =
        "#{t('find_assessor_by_name.top_heading')} – #{
          t('services.getting_an_energy_certificate')
        } – #{t('layout.body.govuk')}"

      if params["name"]
        begin
          raise Errors::InvalidName if params["name"].is_a?(Array)

          response = response.execute(params["name"], "nonDomestic")

          locals[:results] = response[:data][:assessors]
          locals[:meta] = response[:meta]

          erb_template = :find_non_domestic_assessor_by_name_results
          search_results_heading = t((locals[:meta][:looseMatch] ? "find_assessor_by_name_results.results.results_like" : "find_assessor_by_name_results.results.results"), count: locals[:results].length, name: params["name"])
          @page_title = "#{search_results_heading} – #{t('services.getting_an_energy_certificate')} – #{t('layout.body.govuk')}"
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

    get "/find-a-non-domestic-assessor/search-by-postcode",
        host_name: /#{GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME}/ do
      @errors = {}
      locals = {}
      erb_template = :find_non_domestic_assessor_by_postcode

      response =
        @container.get_object(:find_non_domestic_assessor_by_postcode_use_case)

      @page_title =
        "#{t('find_non_domestic_assessor_by_postcode.top_heading')} – #{
          t('services.getting_an_energy_certificate')
        } – #{t('layout.body.govuk')}"

      if params["postcode"]

        begin
          raise Errors::PostcodeWrongFormat if params["postcode"].is_a?(Array)

          params["postcode"].strip!

          locals[:results] =
            response.execute(params["postcode"])[:data][:assessors]

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

    get "/help", host_name: /#{GETTING_NEW_ENERGY_CERTIFICATE_HOST_NAME}/ do
      @page_title =
        "#{t('get_service_help.top_heading')} – #{t('layout.body.govuk')}"
      erb_template = :help_page
      data = { locals_node: "get_service_help" }
      show(erb_template, data)
    end
  end
end
