require 'yaml'
require 'active_record'


module Models
  class RetrosheetEvent < ActiveRecord::Base
    attr_accessor :column_mapping_memo


    class << self
      def column_mapping
        column_mapping_memo ||= YAML::load_file(File.join(Retrodb::ROOT, 'config', 'retrosheet_database_mapping.yml'))
      end

      def column_names
        names = []
        column_mapping.map do |i, data|
          names << data['db_column_name']
        end
        names
      end
    end
  end
end
