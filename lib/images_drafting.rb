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
        part_name = pick_item(available_category_parts, exclude, category)
        if part_name
          counters[category_key][part_name]['value'] = counters[category_key][part_name]['value'].to_i - 1
          if part_name != 'blank'
            new_image_parts << category.parts.find {|part| part.name == part_name }
            exclude.concat(counters[category_key][part_name]['exclude']) if counters[category_key][part_name]['exclude']
          else
            new_image_parts << Part.new(category, 'blank')
          end
        else
          fail "Something goes wrong, script could'n find fit '#{category_key}' part for #{new_image_parts.map(&:name)}. Please try again. If error persists call to support or review your exclude item configuration :)"
        end
      end
      images << new_image_parts
    end
    images.shuffle
  end

  private

  def set_blank_values
    counters.each do |key, value|
      total_items_count = counters[key].map { |_key, v| v['value'].to_i }.sum
      counters[key]['blank'] = { 'value' => max_count - total_items_count }
    end
  end

  def pick_item(available_category_parts, exclude, category)
    items = []
    available_category_parts.except(*exclude).each do |key, part|
      part['value'].to_i.times { items.push(key) }
    end

    if items.size > 0
      items.sample
    else
      try_replace_item(category, exclude)
    end
  end

  def try_replace_item(category, exclude)
    puts 'try replace item'

    @images.each_with_index do |parts, i|
      parts.each_with_index do |part, j|
        if part.category.id == category.id && !exclude.include?(part.name)
          available_category_parts = counters[category.key].select { |_key, count| count['value'].to_i > 0 }
          excluded_for_image = parts.map { |part| counters[part.category.key][part.name]['exclude'] }.flatten.compact
          parts_to_replace_name = available_category_parts.except(*excluded_for_image)&.keys.shuffle
          part_to_replace_name = parts_to_replace_name.find do |part_to_replace_name|
            (counters[part.category.key][part_to_replace_name]['exclude'] & parts.map(&:name)).empty?
          end
          if part_to_replace_name
            @images[i][j] = category.parts.find {|part| part.name == part_to_replace_name }
            return part.name
          end
        end
      end
    end
    nil
  end

  def need_generate_more?
    images.size < max_count
  end
end
