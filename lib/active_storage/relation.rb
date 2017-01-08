module ActiveStorage
  class Relation
    include Enumerable

    attr_reader :records

    delegate :count, :each, to: :records

    def initialize(records)
      @records = records
    end

    def where(attrs = {})
      raise ArgumentError, "You must pass an hash as an argument" unless attrs.is_a?(Hash)

      @records = config.adapter.where(records, attrs)

      self
    end

    private

    def config
      ActiveStorage.config
    end
  end
end
