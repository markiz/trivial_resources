module TrivialResources
  module Create
    def create
      create_build_resource!
      resource.update_attributes(params[resource_name])
      respond_with resource
    end

    protected

    def create_build_resource!
      self.resource = build_scope.new(default_build_attributes)
    end

    def default_build_attributes
      {}
    end

    def build_scope
      resource_class.scoped
    end
  end
end
