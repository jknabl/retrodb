require 'csv'

module Parsers
  class TempfileProductionError < StandardError; end;
  class SourceFileNotDownloadedError < StandardError; end;

  class Event
    attr_reader :persister_klass, :start_year, :end_year, :teams

    # parameterize persister so we can swap out for e.g. a different DB adapter
    def initialize(persister_class: Persisters::Event, start_year: 2018, end_year: 2018, teams: ['TOR'])
      @persister_klass = persister_class
      @start_year = start_year
      @end_year = end_year
      @teams = teams
    end

    def parse
      teams.each do |team|
        (start_year..end_year).each { |year| process_file(year, team) }
      end
    end

    private

    def parse_file(year, team)
      puts "-- Starting to process for #{team} #{year} season..."
      raise SourceFileNotDownloadedError unless ensure_downloaded(year, team)
      raise TempfileProductionError unless produce_chadwick_csv(year, team)

      parse_chadwick_csv

      puts "-- Finished processing #{team} #{year} season."
    end

    def ensure_downloaded(year, team)
      downloader = Downloaders::RetrosheetEvents.new(start_year: year, end_year: year)
      downloader.download_all_event_files
      downloader.unzip_all_event_files
      path = Downloaders::RetrosheetEvents::DEFAULT_DOWNLOAD_PATH

      Dir.chdir(File.join(Retrodb::ROOT, 'db'))

      event_file_name = "#{year}#{team}.EVA"
      true if File.exists?(event_file_name)
    end

    def produce_chadwick_csv(year, team)
      event_file_name = "#{year}#{team}.EVA"
      puts "\n  -- Creating CSV tempfile #{event_file_name} using Chadwick..."

      `cwevent -f 0-96 -y #{year} #{event_file_name} > tmp.csv`

      true if File.exists?('./tmp.csv')
    end

    def parse_chadwick_csv
      puts "\n  -- Importing records from Chadwick tempfile to database..."

      save_count = 0
      CSV.foreach('./tmp.csv') do |row|
        database_record_from_csv_row(row)
        save_count += 1
        puts "\n   -- Saved #{save_count} records..." if (save_count % 500) == 0
      end

      cleanup_tempfile
    end

    def database_record_from_csv_row(row)
      record = @persister_klass.new
      record.schema.each do |column_number, data|
        record.attribute_set(data['db_column_name'], row[column_number])
      end

      return true if record.save
      puts "  -- Error saving record :("
    end

    def cleanup_tempfile
      File.delete('./tmp.csv')
    end
  end
end