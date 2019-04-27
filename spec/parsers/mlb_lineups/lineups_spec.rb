require 'spec_helper'
require 'pry'

RSpec.describe 'Parsers::MlbLineups::Lineups' do
  describe '#initialize' do
    it 'is initialized with a page string' do
      parser = Parsers::MlbLineups::Lineups.new(page_string: 'jim')
      expect(parser.page_string).to eq 'jim'
    end

    it 'raises if no page string given' do
      expect{Parsers::MlbLineups::Lineups.new}.to raise_exception(ArgumentError)
    end
  end

  describe '#parse' do
    before do
      VCR.use_cassette('apr_27_lineup.yml') do
        @mlb_response_string = Downloaders::MlbLineups.new(date: Date.new(2019, 04, 27).to_s).download
      end
    end

    it 'does stuff' do
      parser = Parsers::MlbLineups::Lineups.new(page_string: @mlb_response_string)
      parser.parse
    end
  end
end