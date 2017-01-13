require "./lib/active_storage"

ActiveStorage.configure do |config|
  config.database_path = "./spec/fixtures"
end
