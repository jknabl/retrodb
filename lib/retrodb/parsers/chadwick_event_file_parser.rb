require 'csv'
require 'thread/pool'

module Parsers
  # Chadwick event file --> database rows
  class ChadwickEventFileParser
    attr_reader :file_paths, :persister_klass

    def initialize(file_paths:, persister_klass: Persisters::Event)
      @file_paths = file_paths
      @persister_klass = persister_klass
    end

    def parse
      # pool = Thread.pool(20)

      file_paths.each do |path|
        # pool.process do
          parse_chadwick_csv_from(path)
        # end
      end

      # pool.shutdown
    end

    private

    def parse_chadwick_csv_from(path)
      puts "Parsing chadwick CSV #{path}..."
      save_count = 0
      # Postgres concurrent connections set to 100
      pool = Thread.pool(90)
      CSV.foreach(path) do |row|

        pool.process do
          database_record_from_csv_row(row)
          save_count += 1
          puts "\n   -- Saved #{save_count} records..." if (save_count % 500) == 0
        end
      end
      pool.shutdown

      File.delete(path)
    end

    def database_record_from_csv_row(row)
      record = persister_klass.new

      record.schema.each do |column_number, data|
        record.attribute_set(data['db_column_name'], row[column_number])
      end

      return true if record.save
      puts "  -- Error saving record :("
    end
  end
end