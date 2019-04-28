require 'spec_helper'
require 'pry'

RSpec.describe 'Parsers::MlbLineups::Lineups' do
  describe '#initialize' do
    it 'is initialized with a page string' do
      parser = Parsers::MlbLineups::Lineups.new(html_body: 'jim')
      expect(parser.html_body).to eq 'jim'
    end

    it 'raises if no page string given' do
      expect{Parsers::MlbLineups::Lineups.new}.to raise_exception(ArgumentError)
    end
  end

  describe '#parse' do
    before do
      VCR.use_cassette('apr_27_lineup') do
        @mlb_response_string = Downloaders::MlbLineups.new(date: Date.new(2019, 04, 27).to_s).download
      end

      @parser = Parsers::MlbLineups::Lineups.new(html_body: @mlb_response_string)
    end

    it 'returns all home v. away matchups on a date' do
      result = @parser.parse

      expect(result.count).to eq(15)
    end

    it 'returns flat list of lineups when specified' do
      result = @parser.parse(lineup_list: true)

      expect(result.count).to eq(30)
    end
  end
end