require "./lib/active_storage"

class Sku
  include ActiveStorage

  properties :title, :price, :product_id

  belongs_to :product
end
