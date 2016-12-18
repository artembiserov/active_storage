module ActiveStorage
  class Relation
    include Enumerable

    attr_reader :records

    def initialize(records)
      @records = records
    end

    def count
      records.count
    end

    def each(&block)
      records.each(&block)
    end
  end
end
