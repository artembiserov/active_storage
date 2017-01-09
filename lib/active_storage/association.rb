module ActiveStorage
  module Association
    def belongs_to(name, options = {})
      instance_eval do
        foreign_key = options[:foreign_key] || "#{name}_id"

        define_method name do
          klass = name.to_s.classify.constantize
          parent_id = self.public_send(foreign_key)

          klass.where(id: parent_id).first
        end
      end
    end

    def has_many(name, options = {})
      instance_eval do
        define_method name do
          klass = name.to_s.classify.constantize
          foreign_key = options[:foreign_key] || "#{self.class.name.underscore}_id"

          klass.where(foreign_key => id)
        end
      end
    end
  end
end
