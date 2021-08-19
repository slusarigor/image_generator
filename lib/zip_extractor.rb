require 'zip'

class ZipExtractor
  def self.extract_zip(file, destination)
    FileUtils.mkdir_p(destination)

    Zip::File.open(file) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(destination, f.name)
        begin
          zip_file.extract(f, fpath) unless File.exist?(fpath)
        rescue
        end
      end
    end
  end
end
