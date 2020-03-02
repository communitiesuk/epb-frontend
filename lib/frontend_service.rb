# frozen_string_literal: true

require 'erubis'
require 'i18n'
require 'i18n/backend/fallbacks'
require 'sinatra/base'
require 'sinatra/url_for'
require_relative 'container'
require_relative 'helpers'

class FrontendService < Sinatra::Base
  helpers Sinatra::FrontendService::Helpers
  helpers Sinatra::UrlForHelper

  set :erb, escape_html: true
  set :public_folder, (proc { File.join(root, '/../public') })

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    also_reload 'lib/**/*.rb'
  end

  def initialize
    super
    setup_locales

    @container = Container.new
  end

  before { set_locale }

  get '/' do
    @page_title = t('index.head.title')
    erb :index, layout: :layout
  end

  get '/find-an-assessor' do
    @page_title = t('find_an_assessor.head.title')
    erb :find_assessor, layout: :layout
  end

  get '/find-an-assessor/search-by-postcode' do
    @errors = {}
    @erb_template = :find_assessor_by_postcode

    response = @container.get_object(:find_assessor_by_postcode_use_case)

    if params['postcode']
      if valid_postcode.match(params['postcode'])
        @page_title = t('find_assessor_by_postcode_results.head.title')
        begin
          @results = response.execute(params['postcode'])
          @erb_template = :find_assessor_by_postcode_results
        rescue UseCase::FindAssessorByPostcode::PostcodeNotRegistered
          status 404
          @errors[:postcode] =
            t('find_assessor_by_postcode.postcode_not_registered')
        rescue UseCase::FindAssessorByPostcode::PostcodeNotValid
          status 400
          @errors[:postcode] = t('find_assessor_by_postcode.postcode_not_valid')
        rescue Auth::Errors::NetworkConnectionFailed
          status 500
          @erb_template = :error_page_500
        end
      else
        status 400
        @errors[:postcode] = t('find_assessor_by_postcode.postcode_error')
      end
    end

    @page_title = t('find_assessor_by_postcode.head.title')
    erb @erb_template,
        layout: :layout, locals: { errors: @errors, results: @results }
  end

  get '/find-an-assessor/search-by-name' do
    @errors = {}
    @erb_template = :find_assessor_by_name

    response = @container.get_object(:find_assessor_by_name_use_case)

    if params['name']
      @page_title = t('find_assessor_by_name_results.head.title')
      begin
        @erb_template = :find_assessor_by_name_results
        response = response.execute(params['name'])
      rescue UseCase::FindAssessorByName::InvalidName
        status 400
        @erb_template = :find_assessor_by_name
        @errors[:name] = t('find_assessor_by_name.name_error')
      rescue Auth::Errors::NetworkConnectionFailed
        status 500
        @erb_template = :error_page_500
      end
    end

    @page_title = t('find_assessor_by_name.head.title')

    erb @erb_template,
        layout: :layout, locals: { errors: @errors, results: response }
  end

  get '/schemes' do
    @page_title = t('schemes.head.title')
    erb :schemes, layout: :layout
  end

  get '/healthcheck' do
    status 200
  end

  get '/find-a-certificate' do
    @page_title = t('find_a_certificate.head.title')
    erb :find_certificate, layout: :layout
  end

  get '/find-a-certificate/search-by-postcode' do
    @errors = {}
    @erb_template = :find_certificate_by_postcode

    if params['postcode']
      @page_title = t('find_certificate_by_postcode_results.head.title')
      begin
        @erb_template = :find_certificate_by_postcode_results

        @results =
          @container.get_object(:find_certificate_by_postcode_use_case).execute(
            params['postcode']
          )
      rescue UseCase::FindCertificateByPostcode::PostcodeNotValid
        status 400
        @erb_template = :find_certificate_by_postcode
        @errors[:postcode] =
          t('find_certificate_by_postcode.postcode_not_valid')
      rescue Auth::Errors::NetworkConnectionFailed
        status 500
        @erb_template = :error_page_500
      end
    end

    @page_title = t('find_certificate_by_postcode.head.title')
    erb @erb_template,
        layout: :layout, locals: { errors: @errors, results: @results }
  end

  get '/find-a-certificate/search-by-reference-number' do
    @errors = {}
    @erb_template = :find_certificate_by_reference_number

    if params['reference_number']
      @page_title = t('find_certificate_by_reference_number_results.head.title')
      begin
        @erb_template = :find_certificate_by_reference_number_results

        @results =
          @container.get_object(:find_certificate_by_id_use_case)
            .execute(params['reference_number'])
      rescue UseCase::FindCertificateById::ReferenceNumberNotValid
        status 400
        @erb_template = :find_certificate_by_reference_number
        @errors[:reference_number] =
          t('find_certificate_by_reference_number.reference_number_not_valid')
      rescue UseCase::FindCertificateById::CertificateNotFound
        @erb_template = :find_certificate_by_reference_number
        @errors[:reference_number] =
          t(
            'find_certificate_by_reference_number.reference_number_not_registered'
          )
      rescue Auth::Errors::NetworkConnectionFailed
        status 500
        @erb_template = :error_page_500
      end
    end

    @page_title = t('find_certificate_by_reference_number.head.title')
    erb @erb_template,
        layout: :layout, locals: { errors: @errors, results: @results }
  end

  get '/energy-performance-certificate/:assessment_id' do
    use_case = @container.get_object(:fetch_assessment_use_case)
    assessment = use_case.execute(params[:assessment_id])
    status 200
    erb :domestic_energy_performance_certificate,
        layout: :layout, locals: { assessment: assessment }
  rescue StandardError => e
    case e
    when RemoteUseCase::FetchAssessment::AssessmentNotFound
      status 404
    else
      status 500
    end
  end

  not_found do
    status 404
    erb :error_page_404 unless @errors
  end
end
