require "active_support/all"
module TrivialResources
  module Base
    module ClassMethods
      def responder
        Responder
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end

    protected

    def resource_class
      @@resource_class ||= self.class.name.sub(/Controller$/, "").
                                      singularize.classify.constantize
    end

    def resource_name
      @@resource_name ||= resource_class.name.underscore.gsub("/", "_")
    end

    def resource_scope
      if resource_class.respond_to?(:scoped) # rails 4.1 deprecation
        resource_class.scoped
      else
        resource_class.all
      end
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

    def resource_key
      :id
    end

    def identifier_param
      params[:id]
    end

    def not_found_exception_class
      ActiveRecord::RecordNotFound
    end

    def find_resource!
      resource_scope.where(resource_key => identifier_param).first ||
        raise(not_found_exception_class)
    end
  end
end
