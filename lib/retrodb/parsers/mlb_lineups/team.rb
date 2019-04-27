require 'nokogiri'

module Parsers
  module MlbLineups
    class TeamLineup
      attr_reader :mlb_id, :mlb_team_name, :mlb_tricode

      def initialize(mlb_id:, mlb_team_name:)

      end

      def parse_home
        team_name_header = matchup_element.css(".starting-lineups__team-name--home")

        binding.pry
        @mlb_id = team_name_header

      end

      def parse_away
        away_team_header = matchup_element.css(".starting-lineups__team-name--away")
      end
    end
  end
end