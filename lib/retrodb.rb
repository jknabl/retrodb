require "retrodb/version"

module Retrodb
  class Error < StandardError; end
  # Your code goes here...

  require 'retrodb/downloaders/retrosheet_events'
  require 'retrodb/downloaders/chadwick'

  require 'retrodb/installers/chadwick'

  class << self
    def root
      File.dirname(__dir__)
    end
  end
end
