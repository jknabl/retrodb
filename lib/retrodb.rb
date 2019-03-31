require "retrodb/version"

module Retrodb
  class Error < StandardError; end

  ROOT = File.dirname(__dir__)

  require 'retrodb/downloaders/retrosheet_events'
  require 'retrodb/downloaders/chadwick'

  require 'retrodb/installers/chadwick'

  require 'retrodb/parsers/sqlite_database'
  # Setup database before loading parsers, because parsers migrate.
  database = Parsers::SqliteDatabase.new
  database.setup

  require 'retrodb/parsers/event'
end
