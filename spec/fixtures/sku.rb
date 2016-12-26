require "./lib/active_storage"

class Sku
  include ActiveStorage

  attributes :title, :price, :product_id

  belongs_to :product

  def self.database_path
    "./spec/fixtures"
  end

  private_class_method :database_path
end
