require 'spec_helper'

describe DisqusRails::Forum do
  let!(:forum_hash) do
    {
      :code => 0,
      :response =>  {
        "id" => "bobross",
        "name" => "Bob Ross",
        "founder" => "1",
        "favicon" => {
            "permalink" => "http://disqus.com/api/forums/favicons/bobross.jpg",
            "cache" => "http://mediacdn.disqus.com/1091/images/favicon-default.png"
        }
      }
    }
  end

  let(:forum){ DisqusRails::Forum.new(forum_hash[:response]) }

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

  it "should get forum details information with find method" do
    DisqusRails::Api::Forums
      .should_receive(:details)
      .with(:forum => "bobross")
      .and_return(forum_hash)

    DisqusRails::Forum.find("bobross").should be_a_kind_of(DisqusRails::Forum)
  end

  it "should get forum categories as DisqusRails::Categories class instance" do
    DisqusRails::Api::Forums
      .should_receive(:listCategories)
      .and_return(empty_collection_hash)

    forum.categories.should be_a_kind_of(DisqusRails::Categories)
  end

  it "should get forum threads as DisqusRails::Threads class instance" do
    DisqusRails::Api::Forums
      .should_receive(:listThreads)
      .and_return(empty_collection_hash)

    forum.threads.should be_a_kind_of(DisqusRails::Threads)
  end

  it "should get forum posts as DisqusRails::Posts class instance" do
    DisqusRails::Api::Forums
      .should_receive(:listPosts)
      .and_return(empty_collection_hash)

    forum.posts.should be_a_kind_of(DisqusRails::Posts)
  end

  it "should get forum users as DisqusRails::Users class instance" do
    DisqusRails::Api::Forums
      .should_receive(:listUsers)
      .and_return(empty_collection_hash)

    forum.users.should be_a_kind_of(DisqusRails::Users)
  end

  it "should get forum most active users as DisqusRails::Users class instance" do
    DisqusRails::Api::Forums
      .should_receive(:listMostActiveUsers)
      .and_return(empty_collection_hash)

    forum.most_active_users.should be_a_kind_of(DisqusRails::Users)
  end

  it "should get forum most liked users as DisqusRails::Users class instance" do
    DisqusRails::Api::Forums
      .should_receive(:listMostLikedUsers)
      .and_return(empty_collection_hash)

    forum.most_liked_users.should be_a_kind_of(DisqusRails::Users)
  end

  it "should create forum" do
    DisqusRails::Api::Forums
      .should_receive(:create)
      .with(:website => "stubbed_website", :name => "stubbed_name", :short_name => "stubbed_short_name")
      .and_return({:code => 0, :response => forum_hash})

    DisqusRails::Forum.create(:website => "stubbed_website", :name => "stubbed_name", :short_name => "stubbed_short_name").should be_a_kind_of DisqusRails::Forum
  end
end
