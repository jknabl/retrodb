module Pipelines
  class ImportRosters
    attr_reader :downloader, :downloader_klass, :parser_klass, :parser

    def initialize(downloader_klass: Downloaders::Rosters, parser_klass: Parsers::Rosters)
      @downloader_klass = downloader_klass
      @parser_klass = parser_klass
    end

    def import_pipeline
      parser.parse
    end

    private

    def downloader
      @downloader ||= downloader_klass.new
    end

    def parser
      @parser ||= parser_klass.new(file_paths: downloader.download)
    end
  end
end