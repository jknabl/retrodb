require 'csv'

module Parsers
  class Rosters
    attr_reader :file_paths, :persister_klass, :cleanup

    # Given file paths for Retrosheet Roster files, parse the files and persist.
    def initialize(file_paths:, persister_klass: Persisters::Rosters, cleanup_after_consumptions: false)
      @file_paths = file_paths
      @persister_klass = persister_klass
      @cleanup = cleanup_after_consumptions
    end

    def parse
      parse_csvs
      cleanup_roster_files if cleanup
    end

    private

    def parse_csvs
      file_paths.each do |path|
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

    def cleanup_roster_files
      file_paths.each do |path|
        next unless File.exists?(path)
        File.delete(path)
      end
    end
  end
end

