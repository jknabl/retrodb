require 'csv'

module Parsers
  class TempfileProductionError < StandardError; end;
  class SourceFileNotDownloadedError < StandardError; end;

  class Event
    attr_reader :file_paths, :persister_klass

    def initialize(file_paths:, persister_class: Persisters::Event)
      @file_paths = file_paths
      @persister_klass = persister_class
    end

    def parse
      file_paths.each do |path|
        chadwick_csv_path = create_chadwick_csv_from(path)
        parse_chadwick_csv_from(chadwick_csv_path)
      end
    end

    private

    def create_chadwick_csv_from(path)
      file_name = path.split('/').last # should have event extension, e.g. .EVA
      year = file_name[0..3]
      puts "  -- Creating Chadwick CSV for #{file_name}..."

      Dir.chdir(File.join(Retrodb::ROOT, 'db'))
      `cwevent -f 0-96 -y #{year} #{file_name} > #{file_name + '.tmp'}`
      Dir.chdir(Retrodb::ROOT)

      File.join(Retrodb::ROOT, 'db', file_name + '.tmp')
    end

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
      record = persister_klass.new
      record.schema.each do |column_number, data|
        record.attribute_set(data['db_column_name'], row[column_number])
      end

      return true if record.save
      puts "  -- Error saving record :("
    end
  end
end