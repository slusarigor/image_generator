# MiniMagick.configure do |config|
#   config.validate_on_create = false
# end

class ImageGenerator
  FOLDER = 'results/images/'

  attr_reader :parts, :folder

  def initialize(parts, folder = FOLDER)
    @parts = parts
    @folder = folder
  end

  def generate(new_image_name)
    FileUtils.mkdir_p(folder)

    time = Time.now
    images = parts.reject(&:blank?).map{ |i| Vips::Image.new_from_file(i.path) }
    init_image = images[0]
    init_image = init_image.composite images.drop(1), :over
    init_image.write_to_file("#{folder}#{new_image_name}.png")
    puts "Generate time = #{Time.now - time}"
  end
end
