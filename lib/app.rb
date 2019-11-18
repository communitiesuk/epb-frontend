require 'sinatra/base'

class FrontendService < Sinatra::Base
  set :public_folder, proc do
    File.join(root, '/../public')
  end

  get '/' do
    erb :index
  end

  get '/healthcheck' do
    200
  end
end
