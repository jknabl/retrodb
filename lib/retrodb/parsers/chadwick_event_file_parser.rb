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

      pool = Thread.pool(25)
      file_paths.each do |path|
        pool.process do
          parse_chadwick_csv_from(path)
        end
      end
      pool.shutdown
    end

    private

    def parse_chadwick_csv_from(path)
      puts "Parsing chadwick CSV #{path}..."

      import_from_csv(path)
      File.delete(path)
    rescue => e
      puts "Error: #{e.message} #{e.backtrace}"
      raise
    end

    def import_from_csv(path)
      count, batch = 0, []
      CSV.foreach(path) do |row|
        row.push(DateTime.now)
        row.push(DateTime.now)
        batch << row

        count += 1
        if (count == 5000)
          columns = Models::RetrosheetEvent.column_names
          columns.push(:updated_at)
          columns.push(:created_at)
          persister.with_connection { Models::RetrosheetEvent.import(columns, batch, validate: false) }


          count = 0
          batch = []
        end
      end

      columns = Models::RetrosheetEvent.column_names
      columns.push(:updated_at)
      columns.push(:created_at)
      persister.with_connection { Models::RetrosheetEvent.import(columns, batch, validate: false) }

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