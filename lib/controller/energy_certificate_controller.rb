# frozen_string_literal: true

module Controller
  class EnergyCertificateController < BaseController
    get "/energy-certificate/:assessment_id" do
      use_case = @container.get_object(:fetch_certificate_use_case)
      assessment = use_case.execute(params[:assessment_id])
      @page_title =
        " – #{t('services.find_an_energy_certificate')} – #{
          t('layout.body.govuk')
        }"
      @display_language_toggle = true
      use_print_view = params["print"] == "true"

      cache_control :public, max_age: 60
      status 200

      case assessment[:data][:typeOfAssessment]
      when "CEPC"
        @page_title = "#{t('non_domestic_epc.top_heading')}#{@page_title}"
        show_with_print_option :non_domestic_energy_performance_certificate,
                               { assessment: assessment[:data] },
                               use_print_view
      when "CEPC-RR"
        @page_title = "#{t('non_domestic_epc.rr.top_heading')}#{@page_title}"
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
          "#{t('dec_rr.top_heading')}#{@page_title}"
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
        status 410
        erb :error_page_410
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
    rescue Errors::AssessmentNotFound, Errors::AssessmentUnsupported
      not_found
    end
  end
end
