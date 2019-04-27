require 'nokogiri'

module Parsers
  module MlbLineups
    class TeamLineup
      attr_reader :matchup_element, :home_team, :team_header_element, :team_pitcher_element, :lineup_elements

      def initialize(matchup_element:, home_team: true)
        @matchup_element = matchup_element
        @home_team = home_team
      end

      def parse
        parse_team_header.merge(
          {
            pitcher: parse_pitcher,
            lineup: parse_lineup
          }
        )
      end

      private

      def parse_team_header
        {
          team_name: team_header_element.text.gsub(/\s+/, ""),
          tricode: team_header_element['data-tri-code'],
          mlb_id: team_header_element['data-id'].to_i
        }
      end

      def parse_pitcher
        {
          name: team_pitcher_element.css('.starting-lineups__pitcher-name').text.strip,
          throwing_hand: team_pitcher_element.css('.starting-lineups__pitcher-pitch-hand').text.gsub(/\s+/, ""),
          wins: team_pitcher_element.css('.starting-lineups__pitcher-wins').text.gsub(/\s+/, "").to_i,
          losses: team_pitcher_element.css('.starting-lineups__pitcher-losses').text.gsub(/\s+/, "").to_i,
          era: team_pitcher_element.css('.starting-lineups__pitcher-era').text.gsub(/\s+|ERA/, "").to_d,
          strikeouts: team_pitcher_element.css('.starting-lineups__pitcher-strikeouts').text.gsub(/\s+|SO/, "").to_i,
          mlb_link: team_pitcher_element.css("a").first['href'],
          mlb_id: team_pitcher_element.css("a").first['href'].match(/player\/(\d+)\//) { $1.to_i }
        }
      end

      def parse_lineup_player_element(player_element)
        link_element = player_element.css('.starting-lineups__player--link').first
        bats = player_element.css('.starting-lineups__player--position').text.match(/(\(\w+\))/) do
          $1.gsub(/\(|\)/, "")
        end

        {
          name: link_element.text.strip,
          link: link_element['href'],
          mlb_id: link_element['href'].match(/player\/(\d+)\//) { $1.to_i },
          position: player_element.css('.starting-lineups__player--position').text.gsub(/\(\w+\)/, "").gsub(/\s+/, ""),
          batting_hand: bats
        }
      end

      def parse_lineup
        lineup = {}
        lineup_elements.each_with_index do |player_element, i|
          lineup[i + 1] = parse_lineup_player_element(player_element)
        end
        lineup
      end

      def team_header_css_class
        home_team ? ".starting-lineups__team-name--home" : ".starting-lineups__team-name--away"
      end

      def team_header_element
        @team_header_element ||= matchup_element.css(team_header_css_class).first.css('a').first
      end

      def team_pitcher_element
        @team_pitcher_element =  if home_team
          matchup_element.css(".starting-lineups__pitcher-summary")[2]
        else
          matchup_element.css(".starting-lineups__pitcher-summary")[0]
        end
      end

      def lineup_css_class
        home_team ? ".starting-lineups__team--home" : ".starting-lineups__team--away"
      end

      def lineup_elements
        @lineup_elements ||= matchup_element.css(lineup_css_class).first.css('li')
      end
    end
  end
end