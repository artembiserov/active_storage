require "active_storage/relation"

require "active_support/concern"
require "active_support/inflector"
require "active_support/core_ext/hash"
require "active_support/core_ext/time"
require "csv"

module ActiveStorage
  extend ActiveSupport::Concern

  def initialize(params = {})
    self.class.connect

    self.id = params["id"]
    assign_attributes(params.slice(*@@attributes))
  end

  included do |base|
    attr_reader :id

    private
    attr_writer :id
  end

  def assign_attributes(params)
    params.each do |key, value|
      public_send("#{key}=", value)
    end
  end

  def persisted?
    id.present?
  end

  def save
    persisted? ? remove_old_record : generate_id

    insert
  end

  def remove_old_record
    table = CSV.table(self.class.storage_path, col_sep: ";", headers: true)
    table.delete_if { |row| row[:id].to_s == id }

    File.open(self.class.storage_path, "w") do |f|
      f.write(table.to_csv)
    end
  end

  private

  def insert
    CSV.open(self.class.storage_path, "ab", col_sep: ";") do |csv|
      csv << ["id", *@@attributes].map { |attr| public_send(attr) }
    end
  end

  def generate_id
    self.id = Time.current.to_f
  end

  class_methods do
    def count
      records.size
    end

    def where(attrs = {})
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
        Product.new(params)
      end
    end

    def attributes(*attrs)
      @@attributes = attrs.map(&:to_s).reject { |attr| attr == "id" }
      class_eval do
        attr_accessor(*@@attributes)
      end
    end

    def storage_file_name
      "#{self.to_s.tableize}"
    end

    def storage_path
      "#{database_path}/#{storage_file_name}.csv"
    end

    def connect
      return if File.exists?(storage_path)

      CSV.open(storage_path, "ab", col_sep: ";") do |csv|
        csv << ["id", *@@attributes]
      end
    end
  end
end
