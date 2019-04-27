require 'spec_helper'

RSpec.describe 'Parsers::MlbLineups::Matchup' do
  before do
    VCR.use_cassette('apr_27_lineup') do
      @downloader = Downloaders::MlbLineups.new(date: Date.new(2019, 04, 27).to_s)
      @lineup_parser = Parsers::MlbLineups::Lineups.new(page_string: @downloader.download)
      @matchup_element = @lineup_parser.send(:matchup_elements).first
    end
  end


  describe '#initialize' do
    it 'raises if no matchup element given' do
      expect{ Parsers::MlbLineups::Matchup.new }.to raise_exception(ArgumentError)
    end
  end

  describe '#parse' do
    it 'returns a hash of home and away lineups for a matchup' do
      parser = Parsers::MlbLineups::Matchup.new(matchup_element: @matchup_element)
      result = parser.parse

      expect(result.keys.sort).to eq([:away, :home])
      expect(result[:away]).to eq(Parsers::MlbLineups::TeamLineup.new(matchup_element: @matchup_element, home_team: false).parse)
      expect(result[:home]).to eq(Parsers::MlbLineups::TeamLineup.new(matchup_element: @matchup_element, home_team: true).parse)
    end
  end
end