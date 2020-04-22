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
    locals = {}
    erb_template = :find_assessor_by_postcode

    response = @container.get_object(:find_assessor_by_postcode_use_case)

    if params['postcode']
      if valid_postcode.match(params['postcode'])
        @page_title = t('find_assessor_by_postcode_results.head.title')
        begin
          locals[:results] =
            response.execute(params['postcode'])[:data][:assessors]
          erb_template = :find_assessor_by_postcode_results
        rescue Errors::PostcodeNotRegistered
          status 404
          @errors[:postcode] =
            t('find_assessor_by_postcode.postcode_not_registered')
        rescue Errors::PostcodeNotValid
          status 400
          @errors[:postcode] = t('find_assessor_by_postcode.postcode_not_valid')
        rescue Auth::Errors::NetworkConnectionFailed
          status 500
          erb_template = :error_page_500
        end
      else
        status 400
        @errors[:postcode] = t('find_assessor_by_postcode.postcode_error')
      end
    end

    @page_title = t('find_assessor_by_postcode.head.title')

    show(erb_template, locals)
  end

  get '/find-an-assessor/search-by-name' do
    @errors = {}
    locals = {}
    erb_template = :find_assessor_by_name

    response = @container.get_object(:find_assessor_by_name_use_case)

    if params['name']
      @page_title = t('find_assessor_by_name_results.head.title')
      begin
        erb_template = :find_assessor_by_name_results
        response = response.execute(params['name'])

        locals[:results] = response[:data][:assessors]
        locals[:meta] = response[:meta]
      rescue Errors::InvalidName
        status 400
        erb_template = :find_assessor_by_name
        @errors[:name] = t('find_assessor_by_name.name_error')
      rescue Auth::Errors::NetworkConnectionFailed
        status 500
        erb_template = :error_page_500
      end
    end

    @page_title = t('find_assessor_by_name.head.title')

    show(erb_template, locals)
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
    locals = {}
    erb_template = :find_certificate_by_postcode

    if params['postcode']
      @page_title = t('find_certificate_by_postcode_results.head.title')
      begin
        erb_template = :find_certificate_by_postcode_results

        locals[:results] =
          @container.get_object(:find_certificate_by_postcode_use_case).execute(
            params['postcode']
          )[
            :data
          ][
            :assessments
          ]
      rescue Errors::PostcodeNotValid
        status 400
        erb_template = :find_certificate_by_postcode
        @errors[:postcode] =
          t('find_certificate_by_postcode.postcode_not_valid')
      rescue Auth::Errors::NetworkConnectionFailed
        status 500
        erb_template = :error_page_500
      end
    end

    @page_title = t('find_certificate_by_postcode.head.title')
    show(erb_template, locals)
  end

  get '/find-a-non-domestic-assessor/search-by-postcode' do
    @errors = {}
    locals = {}
    erb_template = :find_non_domestic_assessor_by_postcode

    response =
      @container.get_object(:find_non_domestic_assessor_by_postcode_use_case)

    if params['postcode']
      if valid_postcode.match(params['postcode'])
        @page_title = t('find_assessor_by_postcode_results.head.title')
        begin
          locals[:results] =
            response.execute(params['postcode'])[:data][:assessors]

          erb_template = :find_non_domestic_assessor_by_postcode_results
        rescue Errors::PostcodeNotRegistered
          status 404
          @errors[:postcode] =
            t('find_assessor_by_postcode.postcode_not_registered')
        rescue Errors::PostcodeNotValid
          status 400
          @errors[:postcode] = t('find_assessor_by_postcode.postcode_not_valid')
        rescue Auth::Errors::NetworkConnectionFailed
          status 500
          erb_template = :error_page_500
        end
      else
        status 400
        @errors[:postcode] = t('find_assessor_by_postcode.postcode_error')
      end
    end

    @page_title = t('find_non_domestic_assessor_by_postcode.head.title')
    show(erb_template, locals)
  end

  get '/find-a-certificate/search-by-reference-number' do
    @errors = {}
    locals = {}
    erb_template = :find_certificate_by_reference_number

    if params['reference_number']
      @page_title = t('find_certificate_by_reference_number_results.head.title')
      begin
        erb_template = :find_certificate_by_reference_number_results

        locals[:results] =
          @container.get_object(:find_certificate_by_id_use_case).execute(
            params['reference_number']
          )[
            :data
          ][
            :assessments
          ]
      rescue Errors::ReferenceNumberNotValid
        status 400
        erb_template = :find_certificate_by_reference_number
        @errors[:reference_number] =
          t('find_certificate_by_reference_number.reference_number_not_valid')
      rescue Errors::CertificateNotFound
        erb_template = :find_certificate_by_reference_number
        @errors[:reference_number] =
          t(
            'find_certificate_by_reference_number.reference_number_not_registered'
          )
      rescue Auth::Errors::NetworkConnectionFailed
        status 500
        erb_template = :error_page_500
      end
    end

    @page_title = t('find_certificate_by_reference_number.head.title')
    show(erb_template, locals)
  end

  get '/find-a-certificate/search-by-street-name-and-town' do
    @errors = {}
    locals = {}
    erb_template = :find_certificate_by_street_name_and_town

    if params.key?('town') || params.key?('street_name')
      @page_title =
        t('find_certificate_by_street_name_and_town_results.head.title')
      begin
        erb_template = :find_certificate_by_street_name_and_town_results

        locals[:results] =
          @container.get_object(
            :find_certificate_by_street_name_and_town_use_case
          )
            .execute(params['street_name'], params['town'])[
            :data
          ][
            :assessments
          ]
      rescue Errors::AllParamsMissing
        status 400
        erb_template = :find_certificate_by_street_name_and_town
        @errors[:street_name] =
          t('find_certificate_by_street_name_and_town.street_name_missing')
        @errors[:town] =
          t('find_certificate_by_street_name_and_town.town_missing')
      rescue Errors::StreetNameMissing
        status 400
        erb_template = :find_certificate_by_street_name_and_town
        @errors[:street_name] =
          t('find_certificate_by_street_name_and_town.street_name_missing')
      rescue Errors::TownMissing
        status 400
        erb_template = :find_certificate_by_street_name_and_town
        @errors[:town] =
          t('find_certificate_by_street_name_and_town.town_missing')
      rescue Errors::CertificateNotFound
        erb_template = :find_certificate_by_street_name_and_town
        @errors[:generic] = {
          error:
            'find_certificate_by_street_name_and_town.no_such_address.error',
          body: 'find_certificate_by_street_name_and_town.no_such_address.body',
          cta: 'find_certificate_by_street_name_and_town.no_such_address.cta',
          url: '/find-an-assessor'
        }
      rescue Auth::Errors::NetworkConnectionFailed
        status 500
        erb_template = :error_page_500
      end
    end

    @page_title = t('find_certificate_by_street_name_and_town.head.title')
    show(erb_template, locals)
  end

  get '/energy-performance-certificate/:assessment_id' do
    use_case = @container.get_object(:fetch_certificate_use_case)
    assessment = use_case.execute(params[:assessment_id])

    status 200
    show(
      :domestic_energy_performance_certificate,
      assessment: assessment[:data]
    )
  rescue StandardError => e
    case e
    when Errors::AssessmentNotFound
      status 404
    else
      status 500
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
end
