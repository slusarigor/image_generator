class ImageGenerator
  FOLDER = 'results/images/'

  attr_reader :parts, :folder

  def initialize(parts, folder = FOLDER)
    @parts = parts
    @folder = folder
  end

  def generate(new_image_name)
    FileUtils.mkdir_p(folder)

    init_image = MiniMagick::Image.new(parts[0].path)
    result = nil
    parts.each do |part|
      second_image = MiniMagick::Image.new(part.path)
      result = init_image.composite(second_image) do |c|
        c.background "rgba(255,255,255,0.0)"
      end
    end
    result.write("#{folder}#{new_image_name}.png")
  end
end

# first_image  = MiniMagick::Image.new("first.jpg")
# second_image = MiniMagick::Image.new("second.jpg")
# result = first_image.composite(second_image) do |c|
#   c.compose "Over"    # OverCompositeOp
#   c.geometry "+20+20" # copy second_image onto first_image from (20, 20)
# end
# result.write "output.jpg"