require 'csv'

module Parsers
  class Rosters
    attr_reader :persister_klass, :cleanup_roster_files

    def initialize(persister_klass: Persisters::Rosters, cleanup: false)
      @persister_klass = persister_klass
      @cleanup_roster_files = cleanup_roster_files
    end

    def parse
      ensure_downloaded
      parse_csvs
      cleanup_files if cleanup_roster_files
    end

    private

    def ensure_downloaded
      Downloaders::Rosters.new.download
    end

    def roster_file_paths
      Dir[File.join(Downloaders::Rosters::EXTRACTED_PATH, '/*')].grep(/.*.ROS/)
    end

    def parse_csvs
      roster_file_paths.each do |path|
        file_name = path.split('/').last
        year = file_name.split('')[3..6].join.to_i
        puts "  -- Parsing roster file: #{file_name} for year #{year}"
        CSV.foreach(path) { |row| parse_row(row, year) }
      end
    end

    def parse_row(row, year)
      persister_klass.create(
        player_id: row[0],
        last_name: row[1],
        first_name: row[2],
        batting_hand: row[3],
        throwing_hand: row[4],
        team_id: row[5],
        position: row[6],
        year: year
      )
    end

    def cleanup_zipfile
      return unless File.exists?(Downloaders::Rosters::DOWNLOAD_PATH)
      File.delete(Downloaders::Rosters::DOWNLOAD_PATH)
    end

    def cleanup_roster_files
      roster_file_paths.each do |path|
        next unless File.exists?(path)
        File.delete(path)
      end
    end

    def cleanup_files
      cleanup_zipfile
      cleanup_roster_files
    end
  end
end

