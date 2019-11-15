require 'sinatra/base'

class FrontendService < Sinatra::Base
  set :public_folder, '../public'

  get '/' do
    erb :index
  end

  get '/healthcheck' do
    200
  end
end
