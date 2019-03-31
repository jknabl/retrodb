module Persisters
  class Rosters
    include DataMapper::Resource

    property :id, Serial

    property :player_id, String
    property :last_name, String
    property :first_name, String
    property :batting_hand, String
    property :throwing_hand, String
    property :team_id, String
    property :position, String
    property :year, Integer
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!