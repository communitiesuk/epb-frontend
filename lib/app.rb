# frozen_string_literal: true

require 'i18n'
require 'i18n/backend/fallbacks'
require 'sinatra/base'
require 'sinatra/url_for'
require_relative 'container'
require_relative 'helpers'
require './lib/gateway/assessors_gateway'
require './lib/use_case/find_assessor'

class FrontendService < Sinatra::Base
  helpers Sinatra::FrontendService::Helpers
  helpers Sinatra::UrlForHelper

  set :public_folder, (proc { File.join(root, '/../public') })

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
    also_reload 'lib/**/*.rb'
  end

  def initialize
    super(app)
    setup_locales

    @container = Container.new
  end

  before { set_locale }

  get '/' do
    @page_title = t('index.head.title')
    erb :index, layout: :layout
  end

  get '/find-an-assessor' do
    redirect to('/find-an-assessor/search')
  end

  get '/find-an-assessor/search' do
    @errors = {}
    @erb_template = :find_assessor_by_postcode

    response = @container.get_object(:find_assessor_use_case)

    if params['postcode']
      if valid_postcode.match(params['postcode'])
        @page_title = t('find_assessor_results.head.title')
        @erb_template = :find_assessor_by_postcode_results
        begin
          @results = response.execute(params['postcode'])
        rescue UseCase::FindAssessor::PostcodeNotRegistered
          not_found
        rescue UseCase::FindAssessor::PostcodeNotValid
          error(400)
        rescue UseCase::FindAssessor::SchemeNotFound
          error(500)
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

  get '/schemes' do
    @page_title = t('schemes.head.title')
    erb :schemes, layout: :layout
  end

  get '/healthcheck' do
    200
  end

  get '/energy-performance-certificate/:assessment_id' do
    use_case = @container.get_object(:fetch_assessment_use_case)
    assessment = use_case.execute(params[:assessment_id])
    200
    erb :domestic_energy_performance_certificate,
        layout: :layout, locals: { assessment: assessment }
  rescue Exception => e
    case e
    when UseCase::FetchAssessment::AssessmentNotFound
      404
    else
      500
    end
  end

  # 404 Error!
  not_found do
    status 404
    erb :error_page_404
  end
end
