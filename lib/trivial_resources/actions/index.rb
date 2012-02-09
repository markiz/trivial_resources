module TrivialResources
  module Index
    def index
      index_find_resources
      respond_with index_formatted_resources
    end

    protected

    def index_find_resources
      self.resources = index_resource_scope.all
    end

    def index_resource_scope
      resource_scope
    end

    def index_formatted_resources
      resources
    end
  end
end
