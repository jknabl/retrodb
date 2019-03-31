require 'http'

module Downloaders
  class Chadwick
    FILE_NAME = 'chadwick-0.7.1.tar.gz'
    DOWNLOAD_URL = 'https://managedway.dl.sourceforge.net/project/chadwick/chadwick-0.7/chadwick-0.7.1/' + FILE_NAME

    def download
      binding.pry
      file_contents = HTTP.get(DOWNLOAD_URL).to_s

      File.open("#{Retrodb::ROOT}/tmp/#{FILE_NAME}", "wb") do |file|
        file.write(file_contents)
      end
    end

    def cleanup
      File.delete("#{Retrodb::ROOT}/tmp/#{FILE_NAME}")
    end

    def downloaded?
      File.exists?("#{Retrodb::ROOT}/tmp/#{FILE_NAME}")
    end
  end
end