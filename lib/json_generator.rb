require 'json'

class JsonGenerator
  FOLDER = "results/json/"

  attr_reader :parts

  def initialize(parts)
    @parts = parts
  end

  def generate(file_name)
    json = prepare_json
    File.write("results/json/#{file_name}.json", json)
  end

  def prepare_json
    json = {}
    parts.each { |part| json[part.category.name] = part.name }
    json.to_json
  end
end
