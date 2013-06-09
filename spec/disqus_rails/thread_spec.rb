require 'spec_helper'

describe DisqusRails::Thread do
  let!(:thread_hash) do
    {
      :code => 0,
      :response => {
        "category" => "1",
        "reactions" => 0,
        "identifiers" => [],
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

  let(:empty_collection_hash) do
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
      :response => []
    }
  end

  let(:simple_result) do
    {
      :code => 0,
      :response => [{"id" => "4"}]
    }
  end

  let(:updated_thread_hash) do
    updated_thread_hash = thread_hash
    updated_thread_hash[:response]["title"] = "updated thread title"
    updated_thread_hash
  end

  it "should get threads details information with find method" do
    DisqusRails::Api::Threads
      .should_receive(:details)
      .with(:thread => 3)
      .and_return(thread_hash)

    DisqusRails::Thread.find(3).should be_a_kind_of(DisqusRails::Thread)
  end

  it "should get thread posts as DisqusRails::Posts class instance" do
    DisqusRails::Api::Threads
      .should_receive(:listPosts)
      .and_return(empty_collection_hash)

    thread.posts.should be_a_kind_of(DisqusRails::Posts)
  end

  it "should create thread" do
    DisqusRails::Api::Threads
      .should_receive(:create)
      .with(:forum => "stubbed_forum", :title => "stubbed_title")
      .and_return(thread_hash)

    DisqusRails::Thread.create(:forum => "stubbed_forum", :title => "stubbed_title").should be_a_kind_of DisqusRails::Thread
  end

  it "should open thread" do
    DisqusRails::Api::Threads
      .should_receive(:open)
      .with(:thread => thread.id)
      .and_return(simple_result)

    thread.open

    thread.isClosed.should be_false
  end

  it "should close thread" do
    DisqusRails::Api::Threads
      .should_receive(:close)
      .with(:thread => thread.id)
      .and_return(simple_result)

    thread.close

    thread.isClosed.should be_true
  end

  it "should subscribe for a thread" do
    DisqusRails::Api::Threads
      .should_receive(:subscribe)
      .with(:thread => thread.id, :email => nil)
      .and_return(simple_result)

    thread.subscribe
  end

  it "should unsubscribe from a thread" do
    DisqusRails::Api::Threads
      .should_receive(:unsubscribe)
      .with(:thread => thread.id, :email => nil)
      .and_return(simple_result)

    thread.unsubscribe
  end

  it "should vote for a thread" do
    DisqusRails::Api::Threads
      .should_receive(:vote)
      .with(:thread => thread.id, :vote => 1)
      .and_return(simple_result)

    thread.vote(1)

    thread.vote.should == 1
  end

  it "should update thread" do
    DisqusRails::Api::Threads
      .should_receive(:update)
      .with(:title => "updated thread title", :thread => thread.id)
      .and_return(updated_thread_hash)

    thread.update(:title => "updated thread title")

    thread.title.should == "updated thread title"
  end

  it "should return list of threads" do
    DisqusRails::Api::Threads
      .should_receive(:list)
      .and_return(empty_collection_hash)

    DisqusRails::Thread.where().should be_a_kind_of(DisqusRails::Threads)
  end

  it "should return list of popular threads" do
    DisqusRails::Api::Threads
      .should_receive(:listPopular)
      .and_return(empty_collection_hash)

    DisqusRails::Thread.popular.should be_a_kind_of(DisqusRails::Threads)
  end

  it "should return list of hot threads" do
    DisqusRails::Api::Threads
      .should_receive(:listHot)
      .and_return(empty_collection_hash)

    DisqusRails::Thread.hot.should be_a_kind_of(DisqusRails::Threads)
  end
end
