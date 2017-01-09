module ActiveStorage
  module Association
    def belongs_to(name, options = {})
      foreign_key = options[:foreign_key] || "#{name}_id"

      define_method name do
        klass = name.to_s.classify.constantize
        parent_id = public_send(foreign_key)

        klass.where(id: parent_id).first
      end
    end

    def has_many(name, options = {})
      define_method name do
        klass = name.to_s.classify.constantize
        foreign_key = options[:foreign_key] || "#{self.class.name.underscore}_id"

        klass.where(foreign_key => id)
      end
    end
  end
end
