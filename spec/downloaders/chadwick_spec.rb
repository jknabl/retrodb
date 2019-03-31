require 'spec_helper'

RSpec.describe 'Downloaders::Chadwick' do
  describe '#download' do
    before do
      @downloaded_file = double('chadwick.whatever')
      WebMock.stub_request(:get, Downloaders::Chadwick::DOWNLOAD_URL).to_return(status: 200)
    end

    it 'downloads the Chadwick binary' do
      expect(File).to receive(:open).with("#{Retrodb::ROOT}/tmp/#{Downloaders::Chadwick::FILE_NAME}", "wb").and_yield(@downloaded_file)
      expect(@downloaded_file).to receive(:write).once

      Downloaders::Chadwick.new.download
      expect(WebMock).to have_requested(:get, Downloaders::Chadwick::DOWNLOAD_URL).once
    end
  end

  describe '#cleanup' do
    it 'deletes the temporary binary' do
      expect(File).to receive(:delete).with("#{Retrodb::ROOT}/tmp/#{Downloaders::Chadwick::FILE_NAME}")

      Downloaders::Chadwick.new.cleanup
    end
  end

  describe '#downloaded?' do
    it 'returns true if file exists in tmp directory' do
      expect(File).to receive(:exists?).with("#{Retrodb::ROOT}/tmp/#{Downloaders::Chadwick::FILE_NAME}").and_return(true)

     expect(Downloaders::Chadwick.new.downloaded?).to eq(true)
    end

    it 'returns false if file does not exist in tmp directory' do
      expect(File).to receive(:exists?).with("#{Retrodb::ROOT}/tmp/#{Downloaders::Chadwick::FILE_NAME}").and_return(false)

      expect(Downloaders::Chadwick.new.downloaded?).to eq(false)
    end
  end
end