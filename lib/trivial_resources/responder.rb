require "action_controller"
module TrivialResources
  class Responder < ActionController::Responder
    def to_format
      if get? || !has_errors?
        default_render
      else
        display_errors
      end
    rescue ActionView::MissingTemplate => e
      api_behavior(e)
    end

    protected

    def api_behavior(error)
      raise error unless resourceful?

      display_formatted_resource resource
    end

    def display_formatted_resource(resource)
      if resource.kind_of?(Enumerable)
        display_collection resource
      else
        if !resource.respond_to?(:valid?) || resource.valid?
          display resource
        else
          errors = { :errors => resource.errors }
          display(errors, :status => :unprocessable_entity)
        end
      end
    end

    def display_collection(collection)
      result = []
      status = :ok
      if collection.all? {|r| r.respond_to?(:valid?) }
        collection.each do |r|
          if r.valid?
            result << r
          else
            result << { :errors => r.errors }
            status = :unprocessable_entity
          end
        end
      else
        result = collection
      end
      display(result, :status => status)
    end
  end
end
