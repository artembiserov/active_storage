require "active_support/concern"
require "active_support/inflector"
require "active_support/core_ext/hash"
require "active_support/core_ext/time"
require "csv"
require "pry"

require "active_storage/adapters/csv_adapter"
require "active_storage/configuration"
require "active_storage/relation"
require "active_storage/store"
require "active_storage/querying"

module ActiveStorage
  extend ActiveSupport::Concern

  include Store

  mattr_accessor :config do
    ActiveStorage::Configuration
  end

  def initialize(params = {})
    raise ArgumentError, "You must pass an hash as an argument" unless params.is_a?(Hash)

    self.class.connect

    self.id = params["id"]
    assign_attributes(params.slice(*attribute_names))
  end

  included do
    extend Querying

    cattr_accessor :config
    cattr_accessor :attribute_names

    attr_reader :id

    private

    attr_writer :id
  end

  def assign_attributes(params)
    raise ArgumentError, "You must pass an hash as an argument" unless params.is_a?(Hash)

    params.each do |key, value|
      public_send("#{key}=", value)
    end
  end

  def inspect
    "#<#{self.class.name}:#{object_id} #{attributes}>"
  end

  def attributes
    Hash.new { |h, param| h[param] = public_send(param) }.tap do |hash|
      full_attributes_list.each(&hash)
    end
  end

  def full_attributes_list
    ["id"] + attribute_names
  end

  def self.configure(&block)
    config.instance_eval(&block)
  end

  class_methods do
    def properties(*attrs)
      self.attribute_names = attrs.map(&:to_s).reject { |attr| attr == "id" }
      class_eval do
        attr_accessor(*attribute_names)
      end
    end

    def storage_file_name
      to_s.tableize
    end

    def storage_path
      "#{config.database_path}/#{storage_file_name}.csv"
    end

    def connect
      config.adapter.connect(self)
    end
  end
end
