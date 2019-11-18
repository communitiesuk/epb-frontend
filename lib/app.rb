require 'sinatra/base'

class FrontendService < Sinatra::Base
  set :public_folder, Proc.new { File.join(root, "/../public") }

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
