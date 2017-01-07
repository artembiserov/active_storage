module ActiveStorage
  module Configuration
    mattr_accessor :database_path do
      "./database"
    end

    mattr_accessor :col_sep do
      ";"
    end

    mattr_accessor :adapter do
      # CsvAdapter
    end
  end
end
