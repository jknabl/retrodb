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
  end
end