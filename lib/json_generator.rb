require 'json'

class JsonGenerator
  FOLDER = "results/json/"

  attr_reader :parts, :folder

  def initialize(parts, folder = FOLDER)
    @parts = parts
    @folder = folder
  end

  def generate(file_name)
    FileUtils.mkdir_p(folder)

    json = prepare_json
    File.write("#{folder}#{file_name}.json", json)
  end

  def prepare_json
    json = {}
    parts.each { |part| json[part.category.name] = part.name.split('_').last }
    json.to_json
  end
end
