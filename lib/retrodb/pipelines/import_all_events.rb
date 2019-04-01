module Pipelines
  class ImportAllEvents
    attr_reader :downloader_klass, :parser_klass

    def initialize(downloader_klass: Downloaders::RetrosheetEvents, parser_klass: Parsers::Event)
      @downloader_klass = downloader_klass
      @parser_klass = parser_klass
    end

    def import_pipeline
      parser.parse
    end

    def downloader
      @downloader ||= downloader_klass.new
    end

    def parser
      @parser ||= parser_klass.new(file_paths: downloader.download)
    end
  end
end