require 'data_mapper'
require 'yaml'

module Parsers
  class Event
    include DataMapper::Resource

    property :id, Serial

    column_definitions = YAML::load_file(File.join(__dir__,'retrosheet_database_mapping.yml'))

    column_definitions.each do |row_id, data|
      property data['db_column_name'].to_sym, Object.const_get(data['db_column_type'])
    end

    DataMapper.finalize
    DataMapper.auto_upgrade!
  end
end