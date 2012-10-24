module TrivialResources
  module Destroy
    def destroy
      destroy_find_resource!
      resource.destroy
      respond_with resource,
          :status => resource.destroyed? ? :ok : :unprocessable_entity,
          :callback => params[:callback]
    end

    protected

    def destroy_find_resource!
      self.resource = find_resource!
    end
  end
end
