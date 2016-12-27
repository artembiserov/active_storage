require "active_support/concern"
require "active_support/inflector"
require "active_support/core_ext/hash"
require "active_support/core_ext/time"
require "csv"

require "active_storage/relation"
require "active_storage/store"
require "active_storage/querying"

module ActiveStorage
  extend ActiveSupport::Concern

  include Store

  def initialize(params = {})
    self.class.connect

    self.id = params["id"]
    assign_attributes(params.slice(*@@attributes))
  end

  included do
    extend Querying

    attr_reader :id

    private

    attr_writer :id
  end

  def assign_attributes(params)
    params.each do |key, value|
      public_send("#{key}=", value)
    end
  end

  class_methods do
    def attributes(*attrs)
      @@attributes = attrs.map(&:to_s).reject { |attr| attr == "id" }
      class_eval do
        attr_accessor(*@@attributes)
      end
    end

    def storage_file_name
      to_s.tableize
    end

    def storage_path
      "#{database_path}/#{storage_file_name}.csv"
    end

    def database_path
      "./database"
    end

    def connect
      return if File.exist?(storage_path)

      FileUtils.mkdir_p(database_path)
      CSV.open(storage_path, "ab", col_sep: ";") do |csv|
        csv << ["id", *@@attributes]
      end
    end
  end
end
