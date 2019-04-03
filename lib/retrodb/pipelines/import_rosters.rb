module Pipelines
  class ImportRosters
    attr_reader :downloader, :downloader_klass, :parser_klass, :parser, :persister

    def initialize(downloader_klass: Downloaders::Rosters, parser_klass: Parsers::Rosters, persister: Persisters::PostgresDatabase.new)
      @downloader_klass = downloader_klass
      @parser_klass = parser_klass
      @persister = persister
    end

    def import_pipeline
      persister.with_connection do
        parser.parse
      end
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