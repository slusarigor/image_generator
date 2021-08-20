class Part
  attr_reader :path, :name, :category

  def initialize(category, path)
    @path = path
    @name = path.split('/').last.split('.').first
    @category = category
  end

  def to_h
    { name: name, category: category.name }
  end

  def self.all
    Dir["#{PartCategory::PARTS_FOLDER}/*/*"].map { |path| Part.new(self, path) }
  end
end
