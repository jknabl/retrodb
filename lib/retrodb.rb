require "retrodb/version"

module Retrodb
  class Error < StandardError; end

  ROOT = File.dirname(__dir__)

  require 'retrodb/downloaders/retrosheet_events'
  require 'retrodb/downloaders/chadwick'
  require 'retrodb/downloaders/retrosheet_team_ids'
  require 'retrodb/downloaders/rosters'
  require 'retrodb/downloaders/mlb_lineups'

  require 'retrodb/installers/chadwick'

  require 'retrodb/persisters/postgres_database'

  require 'retrodb/models/retrosheet_event'
  require 'retrodb/models/retrosheet_roster'

  require 'retrodb/parsers/retrosheet_event_file_parser'
  require 'retrodb/parsers/chadwick_event_file_parser'
  require 'retrodb/parsers/team_ids'
  require 'retrodb/parsers/rosters'
  require 'retrodb/parsers/mlb_lineups/lineups'
  require 'retrodb/parsers/mlb_lineups/matchup'
  require 'retrodb/parsers/mlb_lineups/team_lineup'

  require 'retrodb/pipelines/import_rosters'
  require 'retrodb/pipelines/import_all_events'

  require 'lahmandb/downloaders/lahman_database'
end
