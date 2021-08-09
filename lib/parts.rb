class Parts
  PARTS_FOLDER = '/images/parts'

  def categories
    ['backgrounds', 'heads']
  end

  def parts(category_name)
    Dir["#{PARTS_FOLDER}/#{category_name}/*"]
  end
end