require "active_support/all"
module TrivialResources
  module Base

    protected

    def responder
      Responder
    end

    def resource_class
      @@resource_class ||= self.class.name.sub(/Controller$/, "").
                                      singularize.classify.constantize
    end

    def resource_name
      @@resource_name ||= resource_class.name.underscore.gsub("/", "_")
    end

    def resource_scope
      resource_class.scoped
    end

    def resource
      instance_variable_get("@#{resource_name}")
    end

    def resource=(value)
      instance_variable_set("@#{resource_name}", value)
    end

    def resources
      instance_variable_get("@#{resource_name.pluralize}")
    end

    def resources=(value)
      instance_variable_set("@#{resource_name.pluralize}", value)
    end

    def resource_identifier
      :id
    end

    def not_found_exception_class
      ActiveRecord::RecordNotFound
    end

    def find_resource!
      resource_scope.
        where(resource_identifier => params[resource_identifier]).first ||
        raise(not_found_exception_class)
    end
  end
end
