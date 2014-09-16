module TrivialResources
  module Create
    def create
      create_build_resource!
      resource.update_attributes(params[resource_name])
      respond_with resource, :callback => params[:callback]
    end

    protected

    def create_build_resource!
      self.resource = build_scope.new(default_build_attributes)
    end

    def default_build_attributes
      {}
    end

    def build_scope
      if resource_class.respond_to?(:scoped) # Rails 4.1 deprecation
        resource_class.scoped
      else
        resource_class
      end
    end
  end
end
