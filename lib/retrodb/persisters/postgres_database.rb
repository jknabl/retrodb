# require 'yaml'
 require 'active_record'


module Persisters
  class PostgresDatabase
    attr_reader :connection, :environment, :config

    def initialize(environment: 'development')
      @environment = environment
      @config ||= YAML::load_file(File.join(Retrodb::ROOT, 'db', 'config.yml'))
    end

    def connect
      @connection ||= ActiveRecord::Base.establish_connection(config[environment])
    end

    def disconnect
      ActiveRecord::Base.clear_active_connections!
      @connection = nil
    end

    def with_connection
      connect
      yield
    ensure
      ActiveRecord::Base.clear_active_connections!
    end
  end
end
