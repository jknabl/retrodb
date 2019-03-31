class FullDatabaseImporter

  def initialize
    @db = Persisters::SqliteDatabase.new
  end

  def import
    clean_database
    import_rosters
    import_events
  end

  private

  def clean_database
    @db.reset
  end

  def import_team_ids

  end

  def import_rosters
    parser = Parsers::Rosters.new
    parser.parse
  end

  def import_events
    parser = Parsers::Event.new(start_year: 1980, end_year: 2018, teams: ['TOR', 'NYA'])
    parser.parse
  end
end