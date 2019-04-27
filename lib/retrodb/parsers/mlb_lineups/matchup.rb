require 'nokogiri'

module Parsers
  module MlbLineups
    class Matchup
      attr_reader :matchup_element

      def initialize(matchup_element:)
        @matchup_element = matchup_element
      end

      def parse
        {
          home: TeamLineup.new(matchup_element: matchup_element).parse,
          away: TeamLineup.new(matchup_element: matchup_element, home_team: false).parse
        }
      end
    end
  end
end