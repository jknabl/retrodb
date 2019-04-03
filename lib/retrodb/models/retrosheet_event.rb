require 'yaml'
require 'active_record'


module Models
  class RetrosheetEvent < ActiveRecord::Base
    attr_accessor :column_mapping_memo


    class << self
      def column_mapping
        column_mapping_memo ||= YAML::load_file(File.join(Retrodb::ROOT, 'config', 'retrosheet_database_mapping.yml'))
      end
    end
  end
end
