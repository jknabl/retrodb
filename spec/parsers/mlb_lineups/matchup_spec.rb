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
    it 'doies stuff' do
      parser = Parsers::MlbLineups::Matchup.new(matchup_element: @matchup_element)
      parser.parse
    end
  end
end