class JsonsUpdator
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def run
    update_files
  end

  private

  def update_files
    files.each do |file|
      data_hash = JSON.parse(File.read(file))
      data_hash['url'] = "#{url}/#{File.basename(file)}"
      File.write(file, data_hash.to_json)
    end
  end

  def files
    @files ||= Dir["#{JsonGenerator::FOLDER}*"]
  end
end