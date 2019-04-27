require 'nokogiri'

module Parsers
  module MlbLineups
    class Matchup
      attr_reader :matchup_element

      def initialize(matchup_element:)
        @matchup_element = matchup_element
      end

      def parse
        home_team = TeamLineup.new(matchup_element: matchup_element).parse
        away_team = TeamLineup.new(matchup_element: matchup_element, home_team: false).parse

        [home_team, away_team]
      end
    end
  end
end