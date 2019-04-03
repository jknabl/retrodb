require 'csv'
require 'thread/pool'

module Parsers
  # Chadwick event file --> database rows
  class ChadwickEventFileParser
    attr_reader :file_paths

    def initialize(file_paths:)
      @file_paths = file_paths
    end

    def parse
      file_paths.each do |path|
        parse_chadwick_csv_from(path)
      end
    end

    private

    def parse_chadwick_csv_from(path)
      puts "Parsing chadwick CSV #{path}..."
      save_count = 0
      CSV.foreach(path) do |row|
         database_record_from_csv_row(row)
         save_count += 1
         puts "\n   -- Saved #{save_count} records..." if (save_count % 500) == 0
      end

      File.delete(path)
    end

    def database_record_from_csv_row(row)
      attribute_hash = {}
      Models::RetrosheetEvent.column_mapping.each do |column_number, data|
        attribute_hash.merge({data['db_column_name'] => row[column_number]})
      end

      Models::RetrosheetEvent.create!(attribute_hash)
    end
  end
end