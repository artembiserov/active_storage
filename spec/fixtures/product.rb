require "./lib/active_storage"

class Product
  include ActiveStorage

  private

  def self.database_path
    "./spec/fixtures"
  end
end
