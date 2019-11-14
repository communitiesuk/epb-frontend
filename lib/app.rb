require 'sinatra/base'

class FrontendService < Sinatra::Base
  get '/' do
    erb :index
  end

  get '/healthcheck' do
    200
  end
end
