require 'spec_helper'

describe DisqusRails::Disquser do

  before :all do
    ::ActiveRecord::Base.extend DisqusRails::Disquser::ActiveRecordMethods

    m = ActiveRecord::Migration.new
    m.verbose = false
    m.create_table :stubbed_disqusers
  end

  after :all do
    m = ActiveRecord::Migration.new
    m.verbose = false
    m.drop_table :stubbed_disqusers
  end

  let(:stubbed_disquser_instance) do
    class StubbedDisquser < ActiveRecord::Base
      acts_as_disquser :username => :fullname, :email => :email, :avatar => Proc.new{ "pic.jpg" }

      def fullname
        "stubbed_users_fullname"
      end

      def email
        "stubbed_users_email"
      end
    end

    StubbedDisquser.new()
  end

  it "should create disqus_params method on active record disquser model" do
    stubbed_disquser_instance.should respond_to("disqus_params")
  end

  it "should return disqus params for user to use in disqus_init helper for sso" do
    stubbed_disquser_instance.save()
    stubbed_disquser_instance.disqus_params[:username].should == "stubbed_users_fullname"
  end

end
