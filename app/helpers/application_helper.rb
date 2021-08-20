module ApplicationHelper
  def input_value(*keys)
    config.dig(*keys) || 0
  end

  def config
    @config ||= begin
                  JSON.parse(File.open('config_attributes.json').read)
                rescue
                  {}
                end
  end
end
