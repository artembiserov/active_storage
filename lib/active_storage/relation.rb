module ActiveStorage
  class Relation
    include Enumerable

    attr_reader :records

    delegate :count, :each, to: :records

    def initialize(records)
      @records = records
    end

    def where(attrs = {})
      raise ArgumentError, "You must pass an hash as an argument" unless params.is_a?(Hash)

      @records = records.select do |record|
        attrs.inject(true) { |result, (key, value)| result && record.public_send(key) == value }
      end
      self
    end
  end
end
