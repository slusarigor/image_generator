class PartCategory
  PARTS_FOLDER = 'images/parts'

  CATEGORIES_NAMES = %w[Backgrounds Heads]

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

  def self.all
    CATEGORIES_NAMES.map { |name| new(name)}
  end

  def self.find_by_key(key)
    all.find {|category| category.key == key}
  end
end
