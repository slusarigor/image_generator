class PartCategory
  PARTS_FOLDER = 'images/parts'

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def key
    name.downcase.gsub(/[^a-z0-9\-_]+/, '-')
  end

  def rand_part
    parts.sample
  end

  def parts
    Dir["#{PARTS_FOLDER}/#{key}/*"].map { |path| Part.new(self, path) }
  end

  def find_part_by_name(part_name)
    parts.select { |part| part.name == part_name}
  end

  def self.all
    Dir["#{PARTS_FOLDER}/*"].map { |name| new(name.split('/').last.split('.').first)}
  end

  def self.find_by_key(key)
    all.find {|category| category.key == key}
  end
end
