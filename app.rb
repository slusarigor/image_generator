class App < Sinatra::Base
  helpers ApplicationHelper
  include FileUtils::Verbose

  set :views, 'app/views'

  get "/" do
    @categories = PartCategory.all
    erb :index
  end

  get '/upload_parts' do
    erb :upload_parts
  end

  get "/single_image_generate" do
    @categories = PartCategory.all
    erb :single_image_generate
  end

  post '/single_image_generate' do
    FileUtils.rm_rf Dir.glob("single_results/single.zip")
    FileUtils.rm_rf Dir.glob('single_results/images/*')
    FileUtils.rm_rf Dir.glob('single_results/json/*')

    file_name = params[:file_name]

    parts = PartCategory.all.map { |category| category.find_part_by_name(params[category.key]) if params[category.key] }.compact.flatten
    ImageGenerator.new(parts, 'single_results/images/').generate(file_name)
    JsonGenerator.new(parts, 'single_results/json/').generate(file_name)
    ZipFileGenerator.new('single_results', 'single_results/single.zip').write
    send_file "single_results/single.zip", :filename => 'single.zip', :type => 'Application/octet-stream'
  end

  post '/upload_parts' do
    File.delete('config_attributes.json') if File.exist?('config_attributes.json')
    FileUtils.rm_rf Dir.glob("images/parts")
    ZipExtractor.extract_zip(params[:file][:tempfile], "images/parts")
    redirect '/'
  end

  get '/generate_json' do
    erb :generate_json
  end

  post '/generate_image' do
    BatchGenerator.run(params) unless BatchGenerator.in_progress?

    redirect '/?success=true'
  end

  post '/update_json' do
    url = params[:url]
    JsonsUpdator.new(url).run

    redirect '/generate_json?success=true'
  end

  get '/download' do
    send_file "results/results.zip", :filename => 'results.zip', :type => 'Application/octet-stream'
  end

  get '/check_generated_items' do
    erb :check_generated_items
  end
end