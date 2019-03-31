module Persisters
  class TeamIds
    include DataMapper::Resource

    property :id, Serial

    property :team_id, String
    property :league_id, String
    property :city_name, String
    property :team_name, String
    property :year_active_from, Integer
    property :year_active_until, Integer
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!