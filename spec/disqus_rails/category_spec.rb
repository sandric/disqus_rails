require 'spec_helper'

describe DisqusRails::Category do
  let!(:category_hash) do
    {
      :code => 0,
      :response =>  {
        "id" => "0",
        "forum" => "stubbed_forum_name",
        "order" => 0,
        "isDefault" => true,
        "title" => "stubbed_title"
      }
    }
  end

  let(:category){ DisqusRails::Category.new(category_hash[:response]) }

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

  it "should get category details information with find method" do
    DisqusRails::Api::Categories
      .should_receive(:details)
      .with(:category => 0)
      .and_return(category_hash)

    DisqusRails::Category.find(0).should be_a_kind_of(DisqusRails::Category)
  end


  it "should get category threads as DisqusRails::Threads class instance" do
    DisqusRails::Api::Categories
      .should_receive(:listThreads)
      .and_return(empty_collection_hash)

    category.threads.should be_a_kind_of(DisqusRails::Threads)
  end

  it "should get category posts as DisqusRails::Posts class instance" do
    DisqusRails::Api::Categories
      .should_receive(:listPosts)
      .and_return(empty_collection_hash)

    category.posts.should be_a_kind_of(DisqusRails::Posts)
  end

  it "should create category" do
    DisqusRails::Api::Categories
      .should_receive(:create)
      .with(:forum => "stubbed_forum_name", :title => "stubbed_title")
      .and_return(category_hash)

    DisqusRails::Category.create(:forum => "stubbed_forum_name", :title => "stubbed_title").should be_a_kind_of DisqusRails::Category
  end

  it "should return list of categories" do
    DisqusRails::Api::Categories
      .should_receive(:list)
      .and_return(empty_collection_hash)

    DisqusRails::Category.where().should be_a_kind_of(DisqusRails::Categories)
  end
end
