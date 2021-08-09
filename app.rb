class App < Sinatra::Base
  set :views, 'app/views'

  get "/" do
    erb :index
  end

  get '/generate_json' do
    erb :generate_json
  end
end