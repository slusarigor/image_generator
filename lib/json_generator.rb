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
    json = { "attributes" => [] }
    parts.each do |part|
      value = { "trait_type": part.category.name.split('_').last, "value": part.name.split('_').last}
      json['attributes'].push(value)
    end
    json.to_json
  end
end
