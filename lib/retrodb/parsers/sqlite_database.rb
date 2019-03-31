require 'data_mapper'
require 'yaml'

module Parsers
  class SqliteDatabase
    attr_reader :file_name, :base_path

    def initialize(base_path: File.join(Retrodb::ROOT, 'db'), file_name: 'database.db')
      @file_name = file_name
      @base_path = base_path
    end

    def setup
      DataMapper.setup(:default, File.join('sqlite://', File.join(base_path, file_name)))
    end
  end
end