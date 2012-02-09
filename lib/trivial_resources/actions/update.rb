module TrivialResources
  module Update
    def update
      update_find_resource!
      resource.update_attributes(params[resource_name])
      respond_with update_formatted_resource
    end

    protected

    def update_find_resource!
      self.resource = find_resource!
    end

    def update_formatted_resource
      resource
    end
  end
end
