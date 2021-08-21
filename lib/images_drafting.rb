class ImagesDrafting
  attr_accessor :counters
  attr_accessor :images, :max_count

  def initialize(count, counters)
    @counters = counters
    @images = []
    @max_count = count.to_i
  end

  def run
    set_blank_values
    while need_generate_more?
      exclude = []
      new_image_parts = []
      counters.each do |category_key, parts_count|
        category = PartCategory.all.find {|c| c.key == category_key }
        available_category_parts = parts_count.select { |_key, count| count['value'].to_i > 0 }
        part_name = pick_item(available_category_parts, exclude)
        if part_name
          counters[category_key][part_name]['value'] = counters[category_key][part_name]['value'].to_i - 1
          if part_name != 'blank'
            new_image_parts << category.parts.find {|part| part.name == part_name }
            exclude.concat(counters[category_key][part_name]['exclude']) if counters[category_key][part_name]['exclude']
          end
        else
          fail "Something goes wrong, script could'n find fit part for #{new_image_parts.map(&:name)}. Please try again. If error persists call to support :)"
        end
      end
      images << new_image_parts
    end
    images
  end

  private

  def set_blank_values
    counters.each do |key, value|
      total_items_count = counters[key].map { |_key, v| v['value'].to_i }.sum
      counters[key]['blank'] = { 'value' => max_count - total_items_count }
    end
  end

  def pick_item(available_category_parts, exclude)
    items = []
    available_category_parts.except(*exclude).each do |key, part|
      part['value'].to_i.times { items.push(key) }
    end
    items.sample
  end

  def need_generate_more?
    images.size < max_count
  end
end
