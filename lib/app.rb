require 'i18n'
require 'i18n/backend/fallbacks'
require 'sinatra/base'
require 'sinatra/url_for'

require_relative 'helpers'

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
    setup_locales

    super
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

    if params['postcode']
      if valid_postcode.match(params['postcode'])
        @page_title = t('find_assessor_results.head.title')
        @erb_template = :find_assessor_by_postcode_results
      else
        status 400
        @errors[:postcode] = t('find_assessor_by_postcode.postcode_error')
      end
    end

    @page_title = t('find_assessor_by_postcode.head.title')
    erb @erb_template,
        layout: :layout, locals: { errors: @errors, results: assessors }
  end

  get '/schemes' do
    @page_title = t('schemes.head.title')
    erb :schemes, layout: :layout
  end

  get '/healthcheck' do
    200
  end
end
