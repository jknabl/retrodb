require 'yaml'
require 'active_record'

module Models
  class RetrosheetEvent < ActiveRecord::Base

    class << self
      def column_mapping
        YAML::load_file(File.join(Retrodb::ROOT, 'config', 'retrosheet_database_mapping.yml'))
      end
    end
  end
end
