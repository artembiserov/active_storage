require "active_support/concern"
require "active_support/inflector"
require "active_support/core_ext/hash"
require "csv"

module ActiveStorage
  extend ActiveSupport::Concern

  def initialize(params)
    params.slice(*@@attributes).each do |key, value|
      public_send("#{key}=", value)
    end
  end

  class_methods do
    def count
      CSV.read(storage_path, col_sep: ";").size - 1 # There are headers
    end

    def where(attrs = {})
      records = CSV.read(storage_path, col_sep: ";")

      headers = records.first
      records = records[1..-1]
      records.map! do |record|
        params = Hash[*[headers, record].transpose.flatten]
        Product.new(params)
      end

      records.select do |record|
        attrs.inject(true) { |result, (key, value)| result && record.public_send(key) == value }
      end
    end

    def attributes(*attrs)
      @@attributes = attrs.map(&:to_s)
      class_eval do
        attr_accessor(*attrs)
      end
    end

    private

    def storage_file_name
      "#{self.to_s.tableize}"
    end

    def storage_path
      "#{database_path}/#{storage_file_name}.csv"
    end

    def database_path
      "./database"
    end
  end
end
