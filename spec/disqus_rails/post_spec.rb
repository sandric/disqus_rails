require 'spec_helper'

describe DisqusRails::Post do
  let!(:post_hash) do
    {
      :code => 0,
      :response => {
        "isJuliaFlagged" => true,
        "isFlagged" => false,
        "forum" => "bobross",
        "parent" => "null",
        "author" => {
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
            },
            "id" => "1",
            "isAnonymous" => false,
            "email" => "example@disqus.com"
        },
        "media" => [],
        "isApproved" => false,
        "dislikes" => 0,
        "raw_message" => "Hello There",
        "id" => "4",
        "thread" => "1",
        "points" => 0,
        "createdAt" => "2011-11-02T02:22:51",
        "isEdited" => false,
        "message" => "Hello There",
        "isHighlighted" => false,
        "ipAddress" => "127.0.0.1",
        "isSpam" => false,
        "isDeleted" => false,
        "likes" => 0
      }
    }
  end

  let(:updated_post_hash) do
    updated_post_hash = post_hash
    updated_post_hash[:response]["raw_message"] = "updated message"
    updated_post_hash[:response]["message"] = "updated message"
    updated_post_hash
  end

  let(:post) do
    DisqusRails::Post.new post_hash[:response]
  end

  let(:simple_result) do
    {
      :code => 0,
      :response => [{"id" => "4"}]
    }
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

  it "should get post details information with find method" do
    DisqusRails::Api::Posts
      .should_receive(:details)
      .with(:post => 1)
      .and_return(post_hash)

    DisqusRails::Post.find(1).should be_a_kind_of(DisqusRails::Post)
  end

  it "should create post" do
    DisqusRails::Api::Posts
      .should_receive(:create)
      .with(:message => "stubbed_message")
      .and_return(post_hash)

    DisqusRails::Post.create(:message => "stubbed_message").author.should be_a_kind_of DisqusRails::User
  end


  it "should highlight post" do
    DisqusRails::Api::Posts
      .should_receive(:highlight)
      .with(:post => post.id)
      .and_return(simple_result)

    post.highlight

    post.isHighlighted.should be_true
  end

  it "should unhighlight post" do
    DisqusRails::Api::Posts
      .should_receive(:unhighlight)
      .with(:post => post.id)
      .and_return(simple_result)

    post.unhighlight

    post.isHighlighted.should be_false
  end

  it "should vote for post" do
    DisqusRails::Api::Posts
      .should_receive(:vote)
      .with(:post => post.id, :vote => 1)
      .and_return(simple_result)

    post.vote(1)

    post.vote.should == 1
  end

  it "should report post" do
    DisqusRails::Api::Posts
      .should_receive(:report)
      .with(:post => post.id)
      .and_return(simple_result)

    post.report

    post.isFlagged.should be_true
  end

  it "should approve post" do
    DisqusRails::Api::Posts
      .should_receive(:approve)
      .with(:post => post.id)
      .and_return(simple_result)

    post.approve

    post.isApproved.should be_true
  end

  it "should mark post as spam" do
    DisqusRails::Api::Posts
      .should_receive(:spam)
      .with(:post => post.id)
      .and_return(simple_result)

    post.spam

    post.isSpam.should be_true
  end

  it "should remove post" do
    DisqusRails::Api::Posts
      .should_receive(:remove)
      .with(:post => post.id)
      .and_return(simple_result)

    post.remove

    post.isDeleted.should be_true
  end

  it "should restore post" do
    post.isDeleted = true

    DisqusRails::Api::Posts
      .should_receive(:restore)
      .with(:post => post.id)
      .and_return(simple_result)

    post.restore

    post.isDeleted.should be_false
  end

  it "should update post" do

    DisqusRails::Api::Posts
      .should_receive(:update)
      .with(:post => post.id, :message => "updated message")
      .and_return(updated_post_hash)

    post.update("updated message")

    post.message.should == "updated message"
  end

  it "should return list of posts" do
    DisqusRails::Api::Posts
      .should_receive(:list)
      .and_return(empty_collection_hash)

    DisqusRails::Post.where().should be_a_kind_of(DisqusRails::Posts)
  end

  it "should return list of popular posts" do
    DisqusRails::Api::Posts
      .should_receive(:listPopular)
      .and_return(empty_collection_hash)

    DisqusRails::Post.popular.should be_a_kind_of(DisqusRails::Posts)
  end
end
