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

    # time = Time.now
    # init_image = MiniMagick::Image.new(parts[0].path)
    # parts.drop(1).each do |part|
    #   second_image = MiniMagick::Image.new(part.path)
    #   init_image = init_image.composite(second_image) do |c|
    #     c.background "rgba(255,255,255,0.0)"
    #   end
    #   puts 'image part'
    # end
    # init_image.write("#{folder}#{new_image_name}.png")
    # puts Time.now - time


    # time = Time.now
    # convert = MiniMagick::Tool::Convert.new
    # parts.each do |part|
    #   convert << part.path
    # end
    # convert.composite
    # convert << "#{folder}#{new_image_name}.png"
    # convert.call
    #
    # puts "Test + #{Time.now - time}"

    # require 'vips'
    # images = Dir["shots/*"].map{ |i| Vips::Image.new_from_file(i) }
    # sum = images.reduce (:+)
    # avg = sum / images.length
    # avg.write_to_file "out.tif"


    # require 'open-uri'
    # require 'vips'
    #
    # def new_from_uri(uri, options = {})
    #   bytes = open(uri) {|f| f.read}
    #   Vips::Image.new_from_buffer bytes, "", options
    # end
    #
    # a = new_from_uri "https://upload.wikimedia.org/wikipedia/commons/a/a6/Big_Ben_Clock_Face.jpg"
    # b = new_from_uri "https://upload.wikimedia.org/wikipedia/commons/4/47/PNG_transparency_demonstration_1.png"
    # out = a.composite b, "over", x: 100, y: 100
    # out.write_to_file "x.jpg"
    #

    time = Time.now
    images = parts.map{ |i| Vips::Image.new_from_file(i.path) }
    init_image = images[0]
    init_image = init_image.composite images.drop(1), :over
    init_image.write_to_file("#{folder}#{new_image_name}.png")
    puts "Generate time = #{Time.now - time}"
  end
end

# first_image  = MiniMagick::Image.new("first.jpg")
# second_image = MiniMagick::Image.new("second.jpg")
# result = first_image.composite(second_image) do |c|
#   c.compose "Over"    # OverCompositeOp
#   c.geometry "+20+20" # copy second_image onto first_image from (20, 20)
# end
# result.write "output.jpg"