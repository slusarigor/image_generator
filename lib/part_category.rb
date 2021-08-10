class PartCategory
  PARTS_FOLDER = 'images/parts'

  CATEGORIES_NAMES = %w[Backgrounds Heads]

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def key
    name.downcase
  end

  def parts
    Dir["#{PARTS_FOLDER}/#{key}/*"].map { |path| Part.new(path) }
  end

  def self.all
    CATEGORIES_NAMES.map { |name| new(name)}
  end
end
