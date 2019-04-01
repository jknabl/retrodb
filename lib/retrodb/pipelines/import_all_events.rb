module Pipelines
  class ImportAllEvents
    attr_reader :downloader_klass, :parser_klass

    def initialize(downloader_klass: Downloaders::RetrosheetEvents, parser_klass: Parsers::RetrosheetEventFileParser)
      @downloader_klass = downloader_klass
      @parser_klass = parser_klass
    end

    def import_pipeline
      downloaded_files = Downloaders::RetrosheetEvents.new.download
      parsed_retrosheet_event_files = Parsers::RetrosheetEventFileParser.new(file_paths: downloaded_files).parse
      parsed_chadwick_event_files = Parsers::ChadwickEventFileParser.new(file_paths: parsed_retrosheet_event_files).parse
    end
  end
end