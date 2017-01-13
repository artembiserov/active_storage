module ActiveStorage
  module Store
    def persisted?
      config.adapter.persisted?
    end

    def save
      config.adapter.save(self)
    end
  end
end
