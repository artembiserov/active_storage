module ActiveStorage
  class Relation
    include Enumerable

    attr_reader :records

    def initialize(records)
      @records = records
    end

    def where(attrs = {})
      @records = records.select do |record|
        attrs.inject(true) { |result, (key, value)| result && record.public_send(key) == value }
      end
      self
    end

    def count
      records.count
    end

    def each(&block)
      records.each(&block)
    end
  end
end
