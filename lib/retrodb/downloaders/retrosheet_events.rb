require 'http'
require 'zip'

module Downloaders
  class YearInputError < StandardError; end;

  class RetrosheetEvents
    attr_reader :download_path, :start_year, :end_year

    EVENT_FILE_EXTENSIONS = ['EVA', 'EVN', 'EDA', 'EDN']
    DEFAULT_DOWNLOAD_PATH = File.join(Retrodb::ROOT, 'tmp')
    EXTRACTION_PATH = File.join(Retrodb::ROOT, 'db')
    MIN_FILE_YEAR = 1920
    MAX_FILE_YEAR = 2010

    def initialize(download_path: DEFAULT_DOWNLOAD_PATH, start_year: 1921, end_year: 2018)
      @download_path = download_path
      @start_year = start_year
      @end_year = end_year
      validate_year_input
    end

    def download
      archive_file_paths = download_archive_files_in_parallel
      event_file_paths = unzip_event_files(archive_file_paths)
      event_file_paths
    end

    private

    def download_archive_files_in_parallel
      threads = []
      uris_for_download.each do |uri|
        threads << Thread.new(uri) do |uri|
          download_event_file(uri)
        end
      end
      threads.map(&:join)
      downloaded_archive_files
    end

    def unzip_event_files(file_paths)
      file_paths.each do |event_file|
        Zip::File.open(event_file) do |zipped_file|
          zipped_file.each do |entry|
            unzipped_path = File.join(EXTRACTION_PATH, entry.name)
            next if File.exists?(unzipped_path)

            zipped_file.extract(entry, unzipped_path)
          end
        end
      end

      downloaded_event_files
    end

    def downloaded_event_files
      Dir[EXTRACTION_PATH + "/*"].grep(/\.EVA$|\.EVN$|\.EDA$|\.EDN$/)
    end

    def downloaded_archive_files
      Dir[DEFAULT_DOWNLOAD_PATH + "/*"].grep(/.*seve.zip/)
    end

    def download_event_file(uri)
      file_name = uri.split('/').last
      write_path = File.join(download_path, file_name)
      return if File.exists?(write_path)

      response = HTTP.get(uri).to_s

      File.open("#{download_path}/#{file_name}", "wb") do |file|
        file.write(response)
      end

      write_path
    end

    def file_years
      (MIN_FILE_YEAR..MAX_FILE_YEAR).step(10)
    end

    def file_year_start
      file_years.select{ |year| start_year >= year }.first
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

    def validate_year_input
      raise YearInputError unless start_year <= end_year
      raise YearInputError unless start_year >= MIN_FILE_YEAR
      raise YearInputError unless end_year <= (MAX_FILE_YEAR + 10)
    end
  end
end