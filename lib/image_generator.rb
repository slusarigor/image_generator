class ImageGenerator
  attr_reader :parts

  def initialize(parts)
    @parts = parts
  end

  def generate
    init_image = MiniMagick::Image.new(parts[0].path)
    result = nil
    parts.each do |part|
      second_image = MiniMagick::Image.new(part.path)
      result = init_image.composite(second_image) {|c| c.compose "Over" }
    end
    result.write("images/generated_images/1.png")
  end
end

# first_image  = MiniMagick::Image.new("first.jpg")
# second_image = MiniMagick::Image.new("second.jpg")
# result = first_image.composite(second_image) do |c|
#   c.compose "Over"    # OverCompositeOp
#   c.geometry "+20+20" # copy second_image onto first_image from (20, 20)
# end
# result.write "output.jpg"