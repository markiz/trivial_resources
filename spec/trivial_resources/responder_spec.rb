require "spec_helper"

describe TrivialResources::Responder do
  module ResponderSpec
    class User
      attr_reader :name
      def initialize(name)
        @name = name
      end

      def valid?
        errors.blank?
      end

      def errors
        []
      end

      def as_json(*opts, &block)
        {:name => name}.as_json(*opts, &block)
      end
    end

    class UsersController < ActionController::Base
      include TrivialResources
      def formats
        [:json]
      end

      def render(*)
      end
    end
  end

  let(:controller) { ResponderSpec::UsersController.new }
  subject { described_class.new(controller, [resources]) }
  before do
    controller.stub(:request) { stub(:get? => true) }
    subject.stub(:to_format) { subject.send(:api_behavior, StandardError.new) }
  end

  context "rendering singular resources" do
    let(:user) { ResponderSpec::User.new("john") }
    let(:resources) { user }

    it "renders resource as json" do
      controller.should_receive(:render).with(hash_including(:json => user))
      subject.respond
    end

    it "renders errors for invalid resources" do
      errors = [[:name, "already taken"]]
      user.stub(:errors) { errors }
      controller.should_receive(:render).with(hash_including(:json => {:errors => user.errors}, :status => :unprocessable_entity))
      subject.respond
    end

    context "when resource is not a model" do
      let(:resources) { {:hello => :world} }
      it "renders resource as is when it's not a model" do
        controller.should_receive(:render).with(hash_including(:json => resources))
        subject.respond
      end
    end
  end

  context "rendering collections" do
    let(:user) { ResponderSpec::User.new("john") }
    let(:resources) { [user] }

    it "renders collection as json" do
      controller.should_receive(:render).with(hash_including(:json => resources))
      subject.respond
    end

    it "renders errors for invalid resources" do
      errors = [[:name, "already taken"]]
      user.stub(:errors) { errors }
      controller.should_receive(:render).with(hash_including(:json => [{:errors => user.errors}], :status => :unprocessable_entity))
      subject.respond
    end

    context "when collection has non-model resources" do
      let(:resources) { [{:hello => :world}] }
      it "renders collection as is" do
        controller.should_receive(:render).with(hash_including(:json => [{:hello => :world}]))
        subject.respond
      end
    end
  end

end
