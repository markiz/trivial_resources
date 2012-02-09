require "spec_helper"

describe TrivialResources::Base do
  module BaseSpec
    class User
    end

    class UsersController
      include TrivialResources::Base

      # For the purpose of testing only
      public(*protected_instance_methods.map(&:to_sym))
    end
  end

  let(:described_class) { BaseSpec::UsersController }

  subject { described_class.new }

  describe "#resource_class" do
    it "deducts resource class from controller name" do
      subject.resource_class.should == BaseSpec::User
    end
  end

  describe "#resource_scope" do
    it "returns resource_class.scoped by default" do
      scope = stub
      BaseSpec::User.should_receive(:scoped).and_return(scope)
      subject.resource_scope.should == scope
    end
  end

  describe "#resource" do
    it "returns appropriate instance variable" do
      resource = stub
      subject.instance_variable_set(:@base_spec_user, resource)
      subject.resource.should == resource
    end
  end

  describe "#resource=" do
    it "sets appropriate instance variable" do
      resource = stub
      subject.resource = resource
      subject.instance_variable_get(:@base_spec_user).should == resource
    end
  end

  describe "#resources" do
    it "returns appropriate instance variable" do
      resources = stub
      subject.instance_variable_set(:@base_spec_users, resources)
      subject.resources.should == resources
    end
  end

  describe "#resources=" do
    it "returns appropriate instance variable" do
      resources = stub
      subject.resources = resources
      subject.instance_variable_get(:@base_spec_users).should == resources
    end
  end
end
