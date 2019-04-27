require 'nokogiri'

module Parsers
  module MlbLineups
    class Lineups
      # Given a string (HTML webpage) produce a hash of lineups.

      attr_reader :page_string, :parsed_page

      def initialize(page_string:)
        @page_string = page_string
      end


      def parse

      end

      private

      def parsed_page
        @parsed_page ||= Nokogiri::HTML::Document.parse(page_string)
      end

      def matchup_elements
        parsed_page.css(".starting-lineups__matchup")
      end
    end
  end
end