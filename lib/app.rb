require 'i18n'
require 'i18n/backend/fallbacks'
require 'sinatra/base'

require_relative 'helpers'

class FrontendService < Sinatra::Base
  helpers Sinatra::FrontendService::Helpers

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
    redirect to('/find-an-assessor/postcode')
  end

  get '/schemes' do
    @page_title = t('schemes.head.title')
    erb :schemes, layout: :layout
  end

  get '/healthcheck' do
    200
  end
end
