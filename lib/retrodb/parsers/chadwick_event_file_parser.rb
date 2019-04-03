require 'csv'
require 'thread/pool'
require 'activerecord-import'

module Parsers
  # Chadwick event file --> database rows
  class ChadwickEventFileParser
    attr_reader :file_paths, :persister

    def initialize(file_paths:, persister: Persisters::PostgresDatabase.new)
      @file_paths = file_paths
      @persister = persister
    end

    def parse
      file_paths.each do |path|
        parse_chadwick_csv_from(path)
      end
    end

    private

    def parse_chadwick_csv_from(path)
      puts "Parsing chadwick CSV #{path}..."
      save_count, to_import = 0, []

      CSV.foreach(path) do |row|
        attribute_hash = {}
        Models::RetrosheetEvent.column_mapping.each do |column_number, data|
          value = {data['db_column_name'] => row[column_number]}
          attribute_hash.merge!(value)
        end

        persister.with_connection do
          to_import << Models::RetrosheetEvent.new(attribute_hash)
          save_count += 1

          if (save_count % 1000) == 0
            Models::RetrosheetEvent.import(to_import)
            to_import = []
            puts "Saved #{save_count} records..."
          end
        end
      end

      File.delete(path)
    end

    def database_record_from_csv_row(row)
      attribute_hash = {}
      Models::RetrosheetEvent.column_mapping.each do |column_number, data|
        attribute_hash.merge({data['db_column_name'] => row[column_number]})
      end

      to_import = []
      (1.1000).each do |i|
        to_import << Models::RetrosheetEvent
      end
      persister.with_connection do
        Models::RetrosheetEvent.create!(attribute_hash)
      end

    end
  end
end