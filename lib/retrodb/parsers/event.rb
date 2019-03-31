require 'data_mapper'

module Parsers
  class Event
    include DataMapper::Resource

    FIELDS_MAP = [
      {
        field_number: 0,
        chadwick_header: 'GAME_ID',
        database_column: :game_id,
        column_type: String
      },
      {
        field_number: 1,
        chadwick_header:
      }
    ]

    property :id, Serial

    # 'Regular' events

    property :game_id, String
    property :away_team_id, String
    property :inning, Integer
    property :batting_team_id,
  end
end