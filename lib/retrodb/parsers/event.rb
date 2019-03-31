module Parsers
  class Event
    attr_reader :persister_klass

    # parameterize persister so we can swap out for e.g. a different DB adapter
    def initialize(persister_class: Persisters::Event)
      @persister_klass = persister_class
    end

    def load_rows
      # load rows from chadwick

      rows_str = `cwevent -n -f 1-96 -y 2018 2018TOR.EVA`
    end

    def read_rows

    end

    def read_row

    end

  end
end