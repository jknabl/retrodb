require "retrodb/version"

module Retrodb
  class Error < StandardError; end
  require 'retrodb/downloaders/retrosheet_events'
  require 'retrodb/downloaders/chadwick'

  require 'retrodb/installers/chadwick'

  require 'retrodb/parsers/event'

  ROOT = File.dirname(__dir__)

  class << self
    def root
      File.dirname(__dir__)
    end
  end
end
