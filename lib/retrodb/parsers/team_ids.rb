require 'csv'

module Parsers
  class TeamIds
    attr_reader :persister_klass

    def initialize(persister_klass: Persisters::TeamIds)
      @persister_klass = persister_klass
    end

    def parse
      ensure_downloaded
      parse_csv
    end

    private

    def ensure_downloaded
      Downloaders::RetrosheetTeamIds.new.download
    end

    def parse_csv
      puts "Parsing TeamIds CSV..."
      CSV.foreach(Downloaders::RetrosheetTeamIds::DOWNLOAD_PATH) do |row|
        record = @persister_klass.create(
          team_id: row[0],
          league_id: row[1],
          city_name: row[2],
          team_name: row[3],
          year_active_from: row[4].to_i,
          year_active_until: row[5].to_i
        )
        puts "Saved record? #{record}"
      end
    end
  end
end