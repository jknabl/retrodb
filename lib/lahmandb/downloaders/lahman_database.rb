require 'http'
require 'zip'

module Downloaders
  class LahmanNotDownloaded < StandardError; end

  class LahmanDatabase
    FILE_NAME = 'v2019.2'
    DOWNLOAD_URL = 'https://codeload.github.com/chadwickbureau/baseballdatabank/zip/' + FILE_NAME
    EXTRACTION_PATH = File.join(Retrodb::ROOT, 'db')

    def download
      downloaded_path = download_zipped_file
      unzip_database(file_path: downloaded_path)
    end

    def cleanup
      File.delete("#{Retrodb::ROOT}/tmp/#{FILE_NAME}")
    end

    def downloaded?
      File.exists?("#{Retrodb::ROOT}/tmp/#{FILE_NAME}")
    end

    private

    def download_zipped_file(url: DOWNLOAD_URL)
      file_contents = HTTP.get(url).to_s
      download_to_path = File.join(Retrodb::ROOT, 'tmp', FILE_NAME)

      File.open(download_to_path, "wb") do |file|
        file.write(file_contents)
      end

      download_to_path
    end

    def unzip_database(file_path: File.join(Retrodb::ROOT, 'tmp', FILE_NAME))
      extracted_paths = []

      raise LahmanNotDownloaded unless File.exists?(file_path)
      Zip::File.open(file_path) do |zipped_file|
        zipped_file.each do |entry|
          unzipped_path = File.join(EXTRACTION_PATH, entry.name)
          extracted_paths << unzipped_path
          next if File.exists?(unzipped_path)
          zipped_file.extract(entry, unzipped_path)
        end
      end

      extracted_paths
    end
  end
end

