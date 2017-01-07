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

    def records
      connect

      table = CSV.read(storage_path, col_sep: ";", headers: true)
      records = table.entries

      records.map do |record|
        params = Hash[*record.to_a.flatten]
        new(params)
      end
    end
  end
end
