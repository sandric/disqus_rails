require 'spec_helper'

describe DisqusRails::User do
  let!(:user_hash) do
    {
      :code => 0,
      :response =>  {
        "username" => "disqus_api",
        "about" => "",
        "name" => "disqus_api",
        "url" => "",
        "isFollowing" => false,
        "isFollowedBy" => false,
        "profileUrl" => "http://disqus.com/disqus_api/",
        "emailHash" => "67f79ed8e10b74abf07a8dfe101bbab2",
        "avatar" => {
          "permalink" => "http://disqus.com/api/users/avatars/disqus_api.jpg",
          "cache" => "http://mediacdn.disqus.com/1091/images/noavatar92.png"
        }
      },
      :id => "1",
      :isAnonymous => false,
      :email => "example@disqus.com"
    }
  end

  let(:user){ DisqusRails::User.new(user_hash[:response]) }

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

  it "should get user details information with find method" do
    DisqusRails::Api::Users
      .should_receive(:details)
      .with(:user => 1)
      .and_return(user_hash)

    DisqusRails::User.find(1).should be_a_kind_of(DisqusRails::User)
  end

  it "should get user forums as DisqusRails::Forums class instance" do
    DisqusRails::Api::Users
      .should_receive(:listForums)
      .and_return(empty_collection_hash)

    user.forums.should be_a_kind_of(DisqusRails::Forums)
  end

  it "should get user active forums as DisqusRails::Forums class instance" do
    DisqusRails::Api::Users
      .should_receive(:listActiveForums)
      .and_return(empty_collection_hash)

    user.active_forums.should be_a_kind_of(DisqusRails::Forums)
  end

  it "should get user active threads as DisqusRails::Threads class instance" do
    DisqusRails::Api::Users
      .should_receive(:listActiveThreads)
      .and_return(empty_collection_hash)

    user.active_threads.should be_a_kind_of(DisqusRails::Threads)
  end

  it "should get user posts as DisqusRails::Posts class instance" do
    DisqusRails::Api::Users
      .should_receive(:listPosts)
      .and_return(empty_collection_hash)

    user.posts.should be_a_kind_of(DisqusRails::Posts)
  end

  it "should get user followers as DisqusRails::Users class instance" do
    DisqusRails::Api::Users
      .should_receive(:listFollowers)
      .and_return(empty_collection_hash)

    user.followers.should be_a_kind_of(DisqusRails::Users)
  end

  it "should get users following users as DisqusRails::Users class instance" do
    DisqusRails::Api::Users
      .should_receive(:listFollowing)
      .and_return(empty_collection_hash)

    user.following.should be_a_kind_of(DisqusRails::Users)
  end
end
