require 'sinatra/base'
require 'i18n'
require 'i18n/backend/fallbacks'

class FrontendService < Sinatra::Base
  set :public_folder, Proc.new { File.join(root, "/../public") }

  I18n.load_path = Dir[File.join(settings.root, '/../locales', '*.yml')]
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.backend.load_translations
  I18n.enforce_available_locales = true
  I18n.available_locales = %w(en cy)

  before /.*/ do
    if I18n.locale_available?(params['lang'])
      I18n.locale = params['lang']
    end
  end

  def t(*args)
    I18n.t(*args)
  end

  def path(url)
    if I18n.locale != I18n.available_locales[0]
      url + ( url.include?('?') ? '&' : '?' ) + 'lang=' + I18n.locale.to_s
    end

    url
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