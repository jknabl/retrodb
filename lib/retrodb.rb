require "retrodb/version"

module Retrodb
  class Error < StandardError; end

  ROOT = File.dirname(__dir__)

  require 'retrodb/downloaders/retrosheet_events'
  require 'retrodb/downloaders/chadwick'
  require 'retrodb/downloaders/retrosheet_team_ids'
  require 'retrodb/downloaders/rosters'

  require 'retrodb/installers/chadwick'

  require 'retrodb/persisters/sqlite_database'
  # Setup database before loading persisters, because persisters migrate.
  database = Persisters::SqliteDatabase.new
  database.setup

  require 'retrodb/persisters/event'
  require 'retrodb/persisters/team_ids'
  require 'retrodb/persisters/rosters'

  require 'retrodb/parsers/event'
  require 'retrodb/parsers/team_ids'
  require 'retrodb/parsers/rosters'

  require 'retrodb/full_database_importer'
end
