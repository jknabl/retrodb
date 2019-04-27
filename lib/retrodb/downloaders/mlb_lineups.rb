require 'http'
require 'pry'
module Downloaders
  class MlbLineups
    attr_reader :date
    def initialize(date: Date.today.to_s)
      @date = date
    end

    def download
      response_body = HTTP.get(request_url)
      response_body.body.to_s
    end

    private

    def base_url
      "https://www.mlb.com/starting-lineups"
    end

    def request_url
      "#{base_url}/#{date}"
    end
  end
end