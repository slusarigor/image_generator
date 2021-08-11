class App < Sinatra::Base
  set :views, 'app/views'

  get "/" do
    @categories = PartCategory.all
    erb :index
  end

  get '/generate_json' do
    erb :generate_json
  end

  post '/generate_image' do
    FileUtils.rm_rf Dir.glob("#{ImageGenerator::FOLDER}/*")
    FileUtils.rm_rf Dir.glob("#{JsonGenerator::FOLDER}/*")

    Thread.new do
      counters = params.to_h
      images = ImagesDrafting.new(counters).run
      images.each_with_index { |parts, index| ImageGenerator.new(parts).generate(index + 1) }
      images.each_with_index { |parts, index| JsonGenerator.new(parts).generate(index + 1) }
    end

    redirect '/?success=true'
  end

  post '/update_json' do
    url = params[:url]
    JsonsUpdator.new(url).run

    redirect '/generate_json?success=true'
  end
end