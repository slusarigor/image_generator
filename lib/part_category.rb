class PartCategory
  PARTS_FOLDER = 'images/parts'

  attr_reader :name, :id

  def initialize(name)
    @name = name
    @id = name.split('_').first.to_i
  end

  def key
    name.split('_').last.downcase.gsub(/[^a-z0-9\-_]+/, '-')
  end

  def rand_part
    parts.sample
  end

  def parts
    Dir["#{PARTS_FOLDER}/#{name}/*"].map { |path| Part.new(self, path) }
  end

  def find_part_by_name(part_name)
    parts.select { |part| part.name == part_name}
  end

  def self.all
    Dir["#{PARTS_FOLDER}/*"].map { |name| new(name.split('/').last.split('.').first)}.sort_by(&:id)
  end

  def self.find_by_key(key)
    all.find {|category| category.key == key}
  end
end
