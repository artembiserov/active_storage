require "./lib/active_storage"

class Product
  include ActiveStorage

  properties :title, :body
end
