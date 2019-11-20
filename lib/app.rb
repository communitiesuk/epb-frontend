require 'sinatra/base'
require_relative 'helpers'
require 'i18n'
require 'i18n/backend/fallbacks'

class FrontendService < Sinatra::Base
  helpers Sinatra::FrontendService::Helpers

  set :public_folder, Proc.new { File.join(root, "/../public") }

  def initialize
    setup_locales

    super

  end

  before do
    set_locale
  end

  get '/' do
    erb :index
  end
  
  get '/schemes' do
    erb :schemes
  end

  get '/healthcheck' do
    200
  end
end