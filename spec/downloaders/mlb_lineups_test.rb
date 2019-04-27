require 'spec_helper'

RSpec.describe 'Downloaders::MlbLineup' do
  it 'is initialized with current date if none is supplied' do
    downloader = Downloaders::MlbLineups.new
    expect(downloader.date).to eq(Date.today.to_s)
  end

  it 'requests from mlb.com' do
    VCR.use_cassette("apr 27 lineup") do
      downloader = Downloaders::MlbLineups.new
      downloader.download
    end
  end
end