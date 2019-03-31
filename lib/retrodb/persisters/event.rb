require 'data_mapper'
require 'yaml'

module Persisters
  class Event
    include DataMapper::Resource

    attr_reader :schema

    property :id, Serial

    column_definitions = YAML::load_file(File.join(Retrodb::ROOT, 'config', 'retrosheet_database_mapping.yml'))

    column_definitions.each do |row_id, data|
      property data['db_column_name'].to_sym, Object.const_get(data['db_column_type'])
    end

    def initialize
      @schema = YAML::load_file(File.join(Retrodb::ROOT, 'config', 'retrosheet_database_mapping.yml'))
    end
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!