require 'nokogiri'

module Parsers
  module MlbLineups
    class Matchup
      attr_reader :matchup_element, :home_team, :away_team, :start_time, :location_name

      def initialize(matchup_element:)
        @matchup_element = matchup_element
      end

      def parse
        @away_team = parse_away_team
      end


      def parse_away_team
        away_team_header = matchup_element.css(".starting-lineups__team-name--away").first.css("a").first

        mlb_id = away_team_header['data-id'].to_i
        mlb_tricode = away_team_header['data-tri-code']
        mlb_team_name = away_team_header.text.gsub(/\s+/, "")

        away_team_pitcher = matchup_element.css(".starting-lineups__pitcher-summary")[0]
        pitcher_mlb_link = away_team_pitcher.css("a").first['href']


        pitcher_name = away_team_pitcher.css('.starting-lineups__pitcher-name').text.gsub(/\s+/, "")
        pitcher_hand = away_team_pitcher.css('.starting-lineups__pitcher-pitch-hand').text.gsub(/\s+/, "")
        pitcher_wins = away_team_pitcher.css('.starting-lineups__pitcher-wins').text.gsub(/\s+/, "").to_i
        pitcher_losses = away_team_pitcher.css('.starting-lineups__pitcher-losses').text.gsub(/\s+/, "").to_i
        pitcher_era = away_team_pitcher.css('.starting-lineups__pitcher-era').text.gsub(/\s+|ERA/, "").to_d
        pitcher_strikeouts = away_team_pitcher.css('.starting-lineups__pitcher-strikeouts').text.gsub(/\s+|SO/, "").to_i

        lineup_slots = matchup_element.css('.starting-lineups__team--away').first.css('li')

        lineup = {}
        lineup_slots.each_with_index do |player_element, i|
          lineup[i + 1] = {}
          link_element = player_element.css('.starting-lineups__player--link').first
          lineup[i + 1]['name'] = link_element.text.strip
          url = link_element['href']
          lineup[i + 1]['link'] = url
          lineup[i + 1]['mlb_id'] = url.match(/player\/(\d+)\//) { $1.to_i }

          bats = player_element.css('.starting-lineups__player--position').text.match(/(\(\w+\))/) do
            $1.gsub(/\(|\)/, "")
          end

          pos = player_element.css('.starting-lineups__player--position').text.gsub(/\(\w+\)/, "").gsub(/\s+/, "")

          lineup[i + 1]['position'] = pos
          lineup[i + 1]['batting_hand'] = bats

        end
      end
    end
  end
end