module ApplicationHelper
  def input_value(*keys)
    config.dig(*keys) || 0
  end

  def json_with_part(part_name)
    json_files.select do |json|
      json[:json]['attributes'].any? {|attribute| attribute['value'] == part_name.split('_').last}
    end
  end

  def json_files
    @json_files = begin
                    Dir["results/json/*"].map { |file| { json: JSON.parse(File.open(file).read), file_name: file.split('/').last } }
                  end
  end

  def config
    @config ||= begin
                  JSON.parse(File.open('config_attributes.json').read)
                rescue
                  {}
                end
  end
end
