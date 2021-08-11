class ImagesDrafting
  attr_accessor :counters
  attr_accessor :images

  def initialize(counters)
    @counters = counters
    @images = []
  end

  def run
    while need_generate_more?
      new_image_parts = []
      counters.each do |category_key, parts_count|
        category = PartCategory.all.find {|c| c.key == category_key }
        available_category_parts = parts_count.select { |_key, count| count.to_i > 0 }
        part_name = available_category_parts.keys.sample
        if part_name
          counters[category_key][part_name] = counters[category_key][part_name].to_i - 1
          new_image_parts << category.parts.find {|part| part.name == part_name }
        end
      end
      images << new_image_parts
    end
    images
  end

  private

  def need_generate_more?
    counters.to_h.first[1].any? {|key, count| count.to_i > 0 }
  end
end
