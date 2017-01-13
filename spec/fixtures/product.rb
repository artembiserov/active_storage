require "./lib/active_storage"

class Product
  include ActiveStorage

  properties :title, :body

  has_many :skus
end
