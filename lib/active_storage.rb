require "active_support/concern"
require 'active_support/inflector'
require "csv"

module ActiveStorage
  extend ActiveSupport::Concern

  private

  class_methods do
    def count
      CSV.read(storage_path, col_sep: ";").size - 1 # There are headers
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
