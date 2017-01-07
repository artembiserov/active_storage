require "./lib/active_storage"

class Product
  include ActiveStorage

  attributes :title, :body
end
