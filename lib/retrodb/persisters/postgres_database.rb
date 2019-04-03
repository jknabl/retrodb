# require 'yaml'
 require 'active_record'


module Persisters
  class PostgresDatabase
    attr_reader :connection, :environment

    def initialize(environment: 'development')
      @environment = environment
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
      disconnect
    end

    private

    def config
      db_configuration_file = File.join(Retrodb::ROOT, 'db', 'config.yml')
      YAML::load_file(db_configuration_file)
    end
  end
end

# module Persisters
#   class PostgresDatabase
#     attr_reader :adapter, :host, :database, :user
#
#     def initialize(adapter: 'postgres', host: 'localhost', database: 'retrodb', user: 'retrodb')
#       @adapter = adapter
#       @host = host
#       @database = database
#       @user = user
#     end
#
#     def setup
#       reset
#     end
#
#     def create
#       ActiveRecord::Base.establish_connection(admin_config)
#       ActiveRecord::Base.connection.create_database(config["database"])
#       puts "Database created."
#     end
#
#     def migrate
#       ActiveRecord::Schema.define do
#         self.verbose = true # or false
#
#         enable_extension "plpgsql"
#         enable_extension "pgcrypto"
#
#         create_table(:events, force: true) do |t|
#           s = YAML::load_file(File.join(Retrodb::ROOT, 'config', 'retrosheet_database_mapping.yml'))
#
#           s.each do |col_no, data|
#             t.send(data['db_column_type'].downcase.to_sym, data['db_column_name'], null: false)
#           end
#         end
#
#         create_table(:rosters, force: true) do |t|
#           t.string :player_id, null: false
#           t.string :last_name, null: false
#           t.string :first_name, null: false
#           t.string :batting_hand, null: false
#           t.string :throwing_hand, null: false
#           t.string :team_id, null: false
#           t.string :position, null: false
#           t.string :year, null: false
#         end
#
#         create_table(:team_ids, force: true) do |t|
#           t.string :team_id, null: false
#           t.string :league_id, null: false
#           t.string :city_name, null: false
#           t.string :team_name, null: false
#           t.integer :year_active_from, null: false
#           t.integer :year_active_until, null: false
#         end
#       end
#       create_schema
#       puts "Database migrated."
#     end
#
#     def drop
#       ActiveRecord::Base.establish_connection(admin_config)
#       ActiveRecord::Base.connection.drop_database(config["database"])
#       puts "Database deleted."
#     end
#
#     def reset
#       drop if ActiveRecord::Base.establish_connection(config)
#       create
#       migrate
#     end
#
#     def create_schema
#       ActiveRecord::Base.establish_connection(config)
#       require 'active_record/schema_dumper'
#       filename = File.join(Retrodb::ROOT, 'db', 'schema.rb')
#       File.open(filename, "w:utf-8") do |file|
#         ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
#       end
#     end
#
#     def generate_migration
#       name = ARGV[1] || raise("Specify name: rake g:migration your_migration")
#       timestamp = Time.now.strftime("%Y%m%d%H%M%S")
#       path = File.expand_path("../db/migrate/#{timestamp}_migration.rb", __FILE__)
#       migration_class = name.split("_").map(&:capitalize).join
#
#       File.open(path, 'w') do |file|
#         file.write <<-EOF
#           class #{migration_class} < ActiveRecord::Migration
#           end
#          EOF
#       end
#     end
#
#     def config
#       YAML::load_file(File.join(Retrodb::ROOT, 'config', 'database.yml'))
#     end
#
#     def admin_config
#       config.merge({'database' => 'postgres', 'schema_search_path' => 'public'})
#     end
#   end
# end