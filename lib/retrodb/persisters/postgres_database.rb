require 'data_mapper'
require 'yaml'

module Persisters
  class PostgresDatabase
    attr_reader :adapter, :host, :database, :user

    def initialize(adapter: 'postgres', host: 'localhost', database: 'retrodb', user: 'retrodb')
      @adapter = adapter
      @host = host
      @database = database
      @user = user
    end

    def setup
      DataMapper.setup(
        :default,
        adapter: adapter,
        host: host,
        database: database,
        user: user
      )
    end

    def reset
      DataMapper.auto_migrate!
    end
  end
end