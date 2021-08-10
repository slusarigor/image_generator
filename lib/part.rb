class Part
  attr_reader :path, :name

  def initialize(path)
    @path = path
    @name = path.split('/').last.split('.').first
  end
end
