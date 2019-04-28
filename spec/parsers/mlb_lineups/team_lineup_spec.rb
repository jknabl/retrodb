require 'spec_helper'

RSpec.describe 'Parsers::MlbLineups::TeamLineup' do
  before do
    VCR.use_cassette('apr_27_lineup') do
      @downloader = Downloaders::MlbLineups.new(date: Date.new(2019, 04, 27).to_s)
      @lineup_parser = Parsers::MlbLineups::Lineups.new(html_body: @downloader.download)
      @matchup_element = @lineup_parser.send(:matchup_elements).first
    end
  end

  describe '#initialize' do
    it 'raises if no matchup element provided' do
      expect{ Parsers::MlbLineups::TeamLineup.new }.to raise_exception(ArgumentError)
    end

    it 'defaults to home team true' do
      parser = Parsers::MlbLineups::TeamLineup.new(matchup_element: @matchup_element)
      expect(parser.home_team).to eq(true)
    end
  end

  describe 'away team parsing' do
    describe 'team summary parsing' do
      before do
        @parser = Parsers::MlbLineups::TeamLineup.new(matchup_element: @matchup_element, home_team: false)
        @result = @parser.parse
      end

      it 'parses team name' do
        expect(@result[:team_name]).to eq("Orioles")
      end

      it 'parses team 3-letter tricode' do
        expect(@result[:tricode]).to eq("BAL")
      end

      it 'parses MLB team ID' do
        expect(@result[:mlb_id]).to eq(110)
      end
    end

    describe 'pitcher parsing' do
      before do
        @parser = Parsers::MlbLineups::TeamLineup.new(matchup_element: @matchup_element, home_team: false)
        @result = @parser.parse[:pitcher]
      end

      it 'parses name and throwing hand' do
        expect(@result[:name]).to eq("Dan Straily")
        expect(@result[:throwing_hand]).to eq("RHP")
      end

      it 'parses wins and losses' do
        expect(@result[:wins]).to eq(1)
        expect(@result[:losses]).to eq(1)
      end

      it 'parses ERA and strikeouts' do
        expect(@result[:era]).to eq("8.59".to_d)
        expect(@result[:strikeouts]).to eq(6)
      end

      it 'parses MLB ID and MLB URL' do
        expect(@result[:mlb_id]).to eq (573185)
        expect(@result[:mlb_link]).to eq("http://m.mlb.com/player/573185/dan-straily")
      end
    end

    describe 'batter parsing' do
      before do
        @parser = Parsers::MlbLineups::TeamLineup.new(matchup_element: @matchup_element, home_team: false)
        @result = @parser.parse[:lineup].first[1]
      end

      it 'parses full name, batting hand, and player position' do
        expect(@result[:name]).to eq('Jonathan Villar')
        expect(@result[:position]).to eq('SS')
        expect(@result[:batting_hand]).to eq('S')
      end

      it 'parses MLB URL and MLB ID' do
        expect(@result[:link]).to eq("http://m.mlb.com/player/542340/jonathan-villar")
        expect(@result[:mlb_id]).to eq(542340)
      end
    end
  end

  describe 'home team parsing' do
    describe 'team summary parsing' do
      before do
        @parser = Parsers::MlbLineups::TeamLineup.new(matchup_element: @matchup_element, home_team: true)
        @result = @parser.parse
      end

      it 'parses team name' do
        expect(@result[:team_name]).to eq("Twins")
      end

      it 'parses team 3-letter tricode' do
        expect(@result[:tricode]).to eq("MIN")
      end

      it 'parses MLB team ID' do
        expect(@result[:mlb_id]).to eq(142)
      end
    end

    describe 'pitcher parsing' do
      before do
        @parser = Parsers::MlbLineups::TeamLineup.new(matchup_element: @matchup_element, home_team: true)
        @result = @parser.parse[:pitcher]
      end

      it 'parses name and throwing hand' do
        expect(@result[:name]).to eq("Jose Berrios")
        expect(@result[:throwing_hand]).to eq("RHP")
      end

      it 'parses wins and losses' do
        expect(@result[:wins]).to eq(3)
        expect(@result[:losses]).to eq(1)
      end

      it 'parses ERA and strikeouts' do
        expect(@result[:era]).to eq("2.97".to_d)
        expect(@result[:strikeouts]).to eq(33)
      end

      it 'parses MLB ID and MLB URL' do
        expect(@result[:mlb_id]).to eq (621244)
        expect(@result[:mlb_link]).to eq("http://m.mlb.com/player/621244/jose-berrios")
      end
    end

    describe 'batter parsing' do
      before do
        @parser = Parsers::MlbLineups::TeamLineup.new(matchup_element: @matchup_element, home_team: true)
        @result = @parser.parse[:lineup].first[1]
      end

      it 'parses full name, batting hand, and player position' do
        expect(@result[:name]).to eq('Max Kepler')
        expect(@result[:position]).to eq("CF")
        expect(@result[:batting_hand]).to eq("L")
      end

      it 'parses MLB URL and MLB ID' do
        expect(@result[:link]).to eq("http://m.mlb.com/player/596146/max-kepler")
        expect(@result[:mlb_id]).to eq(596146)
      end
    end
  end

  describe 'lineup parsing' do
    before do
      @parser = Parsers::MlbLineups::TeamLineup.new(matchup_element: @matchup_element)
      @result = @parser.parse[:lineup]
    end

    it 'produces a 9-player lineup' do
      expect(@result.count).to eq(9)
    end

    it 'indexes batters by position in lineup' do
      expect(@result.keys).to eq((1..9).to_a)
    end
  end

  describe '#parse' do
    it 'parses home team data when home_team is true' do
      parser = Parsers::MlbLineups::TeamLineup.new(matchup_element: @matchup_element, home_team: true)

      expect(parser.parse[:team_name]).to eq("Twins")
    end

    it 'parses away team data when home_team is false' do
      parser = Parsers::MlbLineups::TeamLineup.new(matchup_element: @matchup_element, home_team: false)

      expect(parser.parse[:team_name]).to eq("Orioles")
    end
  end
  
  describe 'TBD entry parsing' do 
    before do
      @matchup_element = @lineup_parser.send(:matchup_elements).last
    end

    it 'returns an entry with TBD name if pitcher is TBD' do
      parser = Parsers::MlbLineups::TeamLineup.new(matchup_element: @matchup_element)
      result = parser.parse

      expect(result[:team_name]).to eq("White Sox")
      expect(result[:pitcher][:name]).to eq("TBD")
    end

    it 'returns a lineup of 9 name TBD players if lineup is still TBD' do
      parser = Parsers::MlbLineups::TeamLineup.new(matchup_element: @matchup_element)
      result = parser.parse

      expect(result[:team_name]).to eq("White Sox")
      expect(result[:lineup].count).to eq(9)
      result[:lineup].each do |position, player|
        expect(player[:name]).to eq("TBD")
      end
    end
  end
end