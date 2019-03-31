require 'http'
require 'zip'

module Downloaders
  class Rosters
    FILE_NAME = 'Rosters.zip'
    DOWNLOAD_URL = "https://www.retrosheet.org/#{FILE_NAME}"
    DOWNLOAD_PATH = File.join(Retrodb::ROOT, 'tmp', FILE_NAME)
    EXTRACTED_PATH = File.join(Retrodb::ROOT, 'db')

    def initialize

    end

    def download
      download_file
      unzip
    end

    private

    def download_file
      return if File.exists?(DOWNLOAD_PATH)
      response = HTTP.get(DOWNLOAD_URL)
      write_temp_file(response.to_s)
    end

    def write_temp_file(contents)
      return if File.exists?(DOWNLOAD_PATH)

      File.open(DOWNLOAD_PATH, 'wb') do |file|
        file.write(contents)
      end
    end

    def unzip
      Zip::File.open(DOWNLOAD_PATH) do |zipped_file|
        zipped_file.each do |entry|
          unzipped_path = File.join(EXTRACTED_PATH, entry.name)
          next if File.exists?(unzipped_path)
          zipped_file.extract(entry, unzipped_path)
        end
      end
    end
  end
end