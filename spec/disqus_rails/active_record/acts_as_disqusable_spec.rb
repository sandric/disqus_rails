require 'spec_helper'

describe DisqusRails::Disqusable do

  before :all do
    ::ActiveRecord::Base.extend DisqusRails::Disqusable::ActiveRecordMethods

    m = ActiveRecord::Migration.new
    m.verbose = false
    m.create_table :stubbed_disqusables
  end

  after :all do
    m = ActiveRecord::Migration.new
    m.verbose = false
    m.drop_table :stubbed_disqusables
  end

  let(:stubbed_disqusable_instance) do
    class StubbedDisqusable < ActiveRecord::Base
      acts_as_disqusable
    end

    StubbedDisqusable.new()
  end

  let!(:thread_hash) do
    {
      :code => 0,
      :response => {
        "category" => "1",
        "reactions" => 0,
        "identifiers" => [
          2
        ],
        "forum" => "bobross",
        "title" => "Hello World",
        "dislikes" => 0,
        "isDeleted" => false,
        "author" => "1",
        "userScore" => 0,
        "id" => "3",
        "isClosed" => false,
        "posts" => 0,
        "link" => "null",
        "likes" => 0,
        "message" => "",
        "ipAddress" => "127.0.0.1",
        "slug" => "hello_world",
        "createdAt" => "2011-11-02T02:22:41"
      }
    }
  end

  let(:thread) do
    DisqusRails::Thread.new thread_hash[:response]
  end

  let(:one_entrance_collection_hash) do
    {
      :cursor =>  {
        "prev" => "null",
        "hasNext" => true,
        "next" => "1368581473195442:0:0",
        "hasPrev" => false,
        "total" => "null",
        "id" => "1368581473195442:0:0",
        "more" => true
      },
      :code => 0,
      :response => [
        {
          "category" => "1",
          "reactions" => 0,
          "identifiers" => [
              1
          ],
          "forum" => "bobross",
          "title" => "Hello World",
          "dislikes" => 0,
          "isDeleted" => false,
          "author" => "1",
          "userScore" => 0,
          "id" => "3",
          "isClosed" => false,
          "posts" => 0,
          "link" => "null",
          "likes" => 0,
          "message" => "",
          "ipAddress" => "127.0.0.1",
          "slug" => "hello_world",
          "createdAt" => "2011-11-02T02:22:41"
        }
      ]
    }
  end

  it "should create disqus_thread method on active record model that ran acts_as_disqusable method in class definition" do
    stubbed_disqusable_instance.should respond_to("disqus_thread")
  end

  it "should return threads as DisqusRails::Threads class invoking disqus_thread method" do
    stubbed_disqusable_instance.save()

    DisqusRails::Api::Threads
      .should_receive(:list)
      .with(:forum=>nil, :"thread:ident"=>stubbed_disqusable_instance.id)
      .and_return(one_entrance_collection_hash)

    stubbed_disqusable_instance.disqus_thread.should be_a_kind_of(DisqusRails::Thread)
  end

  it "should return disqusable model instance that linked to that disqus thread" do
    stubbed_disqusable_instance.save()
    thread.disqusable.should be_a_kind_of(StubbedDisqusable)
  end

end
