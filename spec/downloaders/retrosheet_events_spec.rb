require 'spec_helper'

RSpec.describe 'Downloaders::RetrosheetEvents' do
  describe 'initialization' do
    before do
      @downloader = Downloaders::RetrosheetEvents.new
    end

    it 'has a default download path' do
      expect(@downloader.download_path).to eq("#{Retrodb.root}/tmp")
    end

    it 'has a default start year' do
      expect(@downloader.start_year).to eq(1921)
    end

    it 'has a default end year' do
      expect(@downloader.end_year).to eq(2018)
    end

    it 'raises if end year is less than start year' do
      expect{Downloaders::RetrosheetEvents.new(start_year: 2000, end_year: 1999)}.to raise_exception(Downloaders::YearInputError)
    end

    it 'raises if start year is less than minimum Retrosheet event file year' do
      expect{Downloaders::RetrosheetEvents.new(start_year: 1919)}.to raise_exception(Downloaders::YearInputError)
    end

    it 'raises if end year is more than maximum retrosheet event file year' do
      expect{Downloaders::RetrosheetEvents.new(end_year: 2021)}.to raise_exception(Downloaders::YearInputError)
    end
  end

  describe '#download_all_event_files' do
    before do
      Dir["#{Retrodb.root}/spec/fixtures/event_files/*"].each do |file_name|
        File.open(file_name, "r") do |file|
          WebMock.stub_request(:get, /https:\/\/www.retrosheet.org\/events\/#{file_name.split('/').last}/).to_return(body: file, status: 200)
        end
      end
    end

    after do
      Dir["#{Retrodb.root}/tmp/*"].each{ |name| File.delete(name) }
    end

    it 'downloads an event file and writes API response' do
      file_path = "#{Retrodb.root}/tmp/1920seve.zip"
      downloader = Downloaders::RetrosheetEvents.new(start_year: 1925, end_year: 1929)
      mock_file = double('file')

      expect(File).to receive(:open).with(file_path, 'wb').once.and_yield(mock_file)
      expect(mock_file).to receive(:write)

      downloader.download_all_event_files
    end

    it 'downloads multiple event files' do
      downloader = Downloaders::RetrosheetEvents.new(start_year: 1920, end_year: 2018)

      Dir["#{Retrodb.root}/spec/fixtures/event_files/*"].grep(/.*seve.zip/).each do |file_path|
        file_name = file_path.split('/').last
        mock_file = double(file_name)
        expect(File).to receive(:open).with("#{Retrodb.root}/tmp/#{file_name}", "wb").once.and_yield(mock_file)
        expect(mock_file).to receive(:write)
      end

      downloader.download_all_event_files

      Dir["#{Retrodb.root}/spec/fixtures/event_files/*"].grep(/.*seve.zip/).each do |file_path|
        file_name = file_path.split('/').last
        expect(WebMock).to have_requested(:get, "https://www.retrosheet.org/events/#{file_name}").once
      end
    end
  end

  describe '#unzip_all_event_files' do
    before do
      Dir["#{Retrodb.root}/spec/fixtures/event_files/*"].each do |file_name|
        File.open(file_name, "r") do |file|
          WebMock.stub_request(:get, /https:\/\/www.retrosheet.org\/events\/#{file_name.split('/').last}/).to_return(body: file, status: 200)
        end
      end
    end

    after do
      Dir["#{Retrodb.root}/tmp/*"].each{ |name| File.delete(name) }
    end

    it 'unzips all event files in a directory' do
      downloader = Downloaders::RetrosheetEvents.new
      Dir["#{Retrodb.root}/spec/fixtures/event_files/*"].grep(/.*seve.zip/).each do |file_path|
        file_name = file_path.split('/').last
        expect(Zip::File).to receive(:open).with("#{Retrodb.root}/tmp/#{file_name}").once
      end

      downloader.download_all_event_files
      downloader.unzip_all_event_files
    end
  end
end