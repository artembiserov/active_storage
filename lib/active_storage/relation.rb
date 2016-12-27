module ActiveStorage
  class Relation
    include Enumerable

    attr_reader :records

    delegate :count, :each, to: :records

    def initialize(records)
      @records = records
    end

    def where(attrs = {})
      @records = records.select do |record|
        attrs.inject(true) { |result, (key, value)| result && record.public_send(key) == value }
      end
      self
    end
  end
end
