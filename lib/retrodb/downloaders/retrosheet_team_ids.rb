require 'http'

module Downloaders
  class RetrosheetTeamIds
    DOWNLOAD_URL = "https://www.retrosheet.org/"
    DOWNLOAD_FILE = "TEAMABR.TXT"
    DOWNLOAD_PATH = File.join(Retrodb::ROOT, 'tmp', DOWNLOAD_FILE)
    FULL_DOWNLOAD_URL = DOWNLOAD_URL + DOWNLOAD_FILE


    def download
      return if File.exists?(DOWNLOAD_FILE)
      response_body = HTTP.get(FULL_DOWNLOAD_URL).to_s

      File.open(DOWNLOAD_PATH, 'wb') do |file|
        file.write(response_body)
      end
    end
  end
end