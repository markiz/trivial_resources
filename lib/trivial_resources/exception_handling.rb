module TrivialResources
  module ExceptionHandling
    def self.included(base)
      base.class_eval do
        rescue_from ActiveRecord::RecordNotFound, :with => :not_found!
      end
    end

    protected

    def not_found!
      render(params[:format] => {:error => "Not found"}, :status => :not_found)
    end
  end
end
