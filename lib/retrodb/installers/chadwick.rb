require 'zlib'

module Installers
  class NotDownloadedError < StandardError; end;

  class Chadwick
    attr_reader :downloader

    def initialize
      @downloader = Downloaders::Chadwick.new
    end

    def install
      raise NotDownloadedError unless downloader.download

      extract
      compile
    end

    private

    def extract
      `tar xvzf #{Retrodb::ROOT}/tmp/#{Downloaders::Chadwick::FILE_NAME} -C #{Retrodb::ROOT}/tmp`
    end

    def compile
      extracted_directory_name = 'chadwick-0.7.1'
      extracted_directory_path = "#{Retrodb.root}/tmp/#{extracted_directory_name}"
      Dir.chdir(extracted_directory_path)

      if system './configure'
        puts "Configured"
      else
        puts "Error configuring :("
      end

      if system 'make'
        puts "Made"
      else
        puts "Error running Makefile :("
      end

      if system 'make install'
        puts "Installed"
      else
        puts "Error installing :("
      end

      Dir.chdir(Retrodb::ROOT)
    end
  end
end