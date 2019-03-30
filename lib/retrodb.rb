require "retrodb/version"

module Retrodb
  class Error < StandardError; end
  # Your code goes here...

  require 'retrodb/downloaders/retrosheet_events'

  class << self
    def root
      File.dirname(__dir__)
    end
  end
end
