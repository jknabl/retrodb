require 'nokogiri'

module Parsers
  module MlbLineups
    class Lineups
      # Given a string (HTML webpage) produce a hash of lineups.

      attr_reader :html_body, :parsed_page

      def initialize(html_body:)
        @html_body = html_body
      end


      def parse(lineup_list: false)
        matchups = matchup_elements.map{ |match| Parsers::MlbLineups::Matchup.new(matchup_element: match).parse }
        if lineup_list
          matchups.flat_map { |m| [m[:home], m[:away]] }
        else
          matchups
        end
      end

      private

      def parsed_page
        @parsed_page ||= Nokogiri::HTML::Document.parse(html_body)
      end

      def matchup_elements
        parsed_page.css(".starting-lineups__matchup")
      end
    end
  end
end