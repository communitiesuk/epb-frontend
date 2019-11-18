require 'sinatra/base'

require 'i18n'
require 'i18n/backend/fallbacks'

require 'rack/contrib'

class FrontendService < Sinatra::Base
  set :public_folder, Proc.new { File.join(root, "/../public") }

  use Rack::Locale
  I18n.load_path = Dir[File.join(settings.root, '/../locales', '*.yml')]
  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.backend.load_translations

  I18n.enforce_available_locales = false
  I18n.available_locales = [:cy, 'en-GB']

  def t(*args)
    I18n.t(*args)
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
