require "./lib/active_storage"

class Product
  include ActiveStorage

  attributes :id, :title, :body

  def self.database_path
    "./spec/fixtures"
  end

  private_class_method :database_path
end
