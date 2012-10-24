module TrivialResources
  module Show
    def show
      show_find_resource!
      respond_with show_formatted_resource, :callback => params[:callback]
    end

    protected

    def show_find_resource!
      self.resource = find_resource!
    end

    def show_formatted_resource
      resource
    end
  end
end
