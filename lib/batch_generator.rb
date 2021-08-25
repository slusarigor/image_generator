class BatchGenerator
  @@in_progress = false

  def self.run(params)
    self.in_progress = true
    FileUtils.rm_rf Dir.glob("results/results.zip")
    FileUtils.rm_rf Dir.glob("#{ImageGenerator::FOLDER}/*")
    FileUtils.rm_rf Dir.glob("#{JsonGenerator::FOLDER}/*")
    File.open('config_attributes.json', 'w') { |file| file.write(params.to_json) }

    counters = params[:parts].to_h

    Thread.new do
      begin
        images = ImagesDrafting.new(params[:count].to_i, counters).run
        images.each_with_index { |parts, index| ImageGenerator.new(parts).generate(index) }
        images.each_with_index { |parts, index| JsonGenerator.new(parts).generate(index) }
        ZipFileGenerator.new('results', 'results/results.zip').write
      ensure
        self.in_progress = false
      end
    end
  end

  def self.in_progress?
    @@in_progress
  end

  def self.in_progress=(value)
    @@in_progress = value
  end
end