require 'csv'
require 'thread/pool'

module Parsers
  class TempfileProductionError < StandardError; end;
  class SourceFileNotDownloadedError < StandardError; end;

  # Retrosheet event CSV file --> Chadwick CSV file
  class RetrosheetEventFileParser
    attr_reader :file_paths, :persister_klass

    def initialize(file_paths:, persister_class: Persisters::Event)
      @file_paths = file_paths
      @persister_klass = persister_class
    end

    def parse
      pool = Thread.pool(20)
      output_paths = []
      file_paths.each do |path|
        pool.process do
          output_paths << create_chadwick_csv_from(path)
        end
      end

      pool.shutdown

      output_paths
    end

    private

    def create_chadwick_csv_from(path)
      file_name = path.split('/').last # should have event extension, e.g. .EVA
      year = file_name[0..3]

      if File.exists?(File.join(Retrodb::ROOT, 'db', file_name + '.tmp'))
        puts "  -- Parsed file already existed fpr #{file_name}, moving on..."
      else
        puts "  -- Creating Chadwick CSV for #{file_name}..."

        Dir.chdir(File.join(Retrodb::ROOT, 'db'))
        `cwevent -f 0-96 -y #{year} #{file_name} > #{file_name + '.tmp'}`
        Dir.chdir(Retrodb::ROOT)
      end

      File.join(Retrodb::ROOT, 'db', file_name + '.tmp')
    end
  end
end