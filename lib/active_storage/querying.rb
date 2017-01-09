module ActiveStorage
  module Querying
    def count
      records.size
    end

    def where(attrs = {})
      raise ArgumentError, "You must pass an hash as an argument" unless attrs.is_a?(Hash)

      Relation.new(records).where(attrs)
    end

    def all
      where
    end

    def find(id)
      where(id: id.to_s).first
    end

    def records
      connect
      config.adapter.records(self)
    end
  end
end
