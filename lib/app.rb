require 'sinatra/base'

class FrontendService < Sinatra::Base
  get '/' do
    'Hello world!'
  end

  get '/healthcheck' do
    200
  end
end
