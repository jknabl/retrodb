require 'http'

module Downloaders
  class RetrosheetEvents
    attr_reader :download_path, :start_year, :end_year

    def initialize(download_path: "#{Retrodb.root}/tmp", start_year: 1921, end_year: 2018)
      @download_path = download_path
      @start_year = start_year
      @end_year = end_year
    end

    def download_all_event_files
      threads = []
      uris_for_download.each do |uri|
        threads << Thread.new(uri) do |uri|
          download_event_files(uri)
        end
      end
      threads.map(&:join)
    end

    def download_event_files(uri)
      response = HTTP.get(uri).to_s
      file_name = uri.split('/').last
      open("#{download_path}/#{file_name}", 'wb') do |file|
        file.write(response)
      end
    end

    private

    def min_file_year
      1920
    end

    def max_file_year
      2010
    end

    def file_years
      (min_file_year..max_file_year).step(10)
    end

    def file_year_start
      file_years.select{ |year| start_year > year }.first
    end

    def file_year_end
      file_years.select{ |year| end_year > year }.last
    end

    def file_years_for_download
      (file_year_start..file_year_end).step(10)
    end

    def file_names_for_download
      file_years_for_download.map{ |year| "#{year}seve.zip"}
    end

    def uris_for_download
      file_names_for_download.map{ |uri| base_uri + uri }
    end

    def base_uri
      'https://www.retrosheet.org/events/'
    end
  end
end