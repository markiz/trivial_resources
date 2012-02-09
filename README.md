# trivial_resources

Rails team have recently implemented a bunch of, for the lack of better word,
dubious decisions. For example, for pure json api and a POST-route you can't
just do `respond_with something` where something is a hash or an array of
hashes. Instead, you are required to do `respond_with something, :location => some_location`, where `some_location` **is not used whatsoever** at any point
of request->response cycle.

This library targets to fix this kind of problems and also provide some trivial
CRUD actions.

## Usage

```
class UsersController < ApplicationController
  include TrivialResources::Base
  include TrivialResources::ExceptionHandling # to catch NotFounds etc.
  include TrivialResources::Create
  include TrivialResources::Show
  include TrivialResources::Update
  include TrivialResources::Destroy
  include TrivialResources::Index

  # includes boilerplate for finding resources and doing proper updates
end
```

## Customization

```
class UsersController < ApplicationController
  include TrivialResources::Base
  include TrivialResources::Create

  protected

  # Used in both lookup and building new resources (all actions)
  def resource_class
    Person
  end

  # Used in lookup (index, show, update, destroy actions)
  def resource_scope
    resource_class.active
  end

  # Used in building new resources (create)
  def build_scope
    Person.where(:active => true)
  end

  # This is also used in building new resources (create)
  def default_build_attributes
    {:active => true}
  end

  # Further customizations are available via method-specific calls
  def index_find_resources
    resource_scope.all(:active => true)
  end

  def respond_on_successful_create
    respond_with @resource
  end

  def respond_on_failed_create
    respond_with @resource, :status => :bad_request
  end
end
```
