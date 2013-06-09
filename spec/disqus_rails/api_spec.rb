#require 'spec_helper'
#
#describe DisqusRails::Api do
#
#  before :all do
#    DisqusRails.setup do |config|
#      config::SHORT_NAME = "stubbed_short_name"
#      config::SECRET_KEY = "stubbed_secret_key"
#      config::PUBLIC_KEY = "stubbed_public_key"
#      config::ACCESS_TOKEN = "stubbed_access_token"
#    end
#  end
#
#  let(:forum){:stubbed_forum_name}
#  describe DisqusRails::Api::Posts do
#
#    it "lists posts" do
#      DisqusRails::Api::Posts.list
#    end
#
#    #when spec was written disqus returned 500 and apparently got same server problems
#    #it "lists popular posts" do
#    #  DisqusRails::Api::Posts.listPopular
#    #end
#
#    it "create post" do
#      response = DisqusRails::Api::Posts.create(:message => "test message9...", :thread => 1329721966)
#      post = response[:response]["id"]
#
#      describe "in context of created post" do
#        it "show created post details" do
#          DisqusRails::Api::Posts.details(:post => post)
#        end
#
#        it "update created post" do
#          DisqusRails::Api::Posts.update(:post => post, :message => "new updated message...")
#        end
#
#        it "approve post" do
#          DisqusRails::Api::Posts.approve(:post => post)
#        end
#
#        it "highlight post" do
#          DisqusRails::Api::Posts.highlight(:post => post)
#        end
#
#        it "unhighlight post" do
#          DisqusRails::Api::Posts.unhighlight(:post => post)
#        end
#
#        it "vote for post" do
#          DisqusRails::Api::Posts.vote(:post => post, :vote => 1)
#        end
#
#        it "report a post" do
#          DisqusRails::Api::Posts.report(:post => post)
#        end
#
#        it "mark post as spam" do
#          DisqusRails::Api::Posts.spam(:post => post)
#        end
#
#        it "remove a post" do
#          DisqusRails::Api::Posts.remove(:post => post)
#        end
#
#        it "restore a post" do
#          DisqusRails::Api::Posts.remove(:post => post)
#        end
#
#        it "remove a post" do
#          DisqusRails::Api::Posts.remove(:post => post)
#        end
#      end
#    end
#  end
#
#  describe DisqusRails::Api::Threads do
#    it "lists threads" do
#      DisqusRails::Api::Threads.list
#    end
#
#    it "lists popular threads" do
#      DisqusRails::Api::Threads.listPopular(:forum => forum)
#    end
#
#    it "lists popular threads" do
#      DisqusRails::Api::Threads.listPopular(:forum => forum)
#    end
#
#    it "lists hot threads" do
#      DisqusRails::Api::Threads.listHot(:forum => forum)
#    end
#
#    it "create new thread" do
#      result = DisqusRails::Api::Threads.create(:forum => forum, :title => "new title")
#      thread = result[:response]["id"]
#
#      describe "in context of new created thread" do
#
#        it "show thread details" do
#          DisqusRails::Api::Threads.details :thread => thread
#        end
#
#        it "list threads posts" do
#          DisqusRails::Api::Threads.listPosts :thread => thread
#        end
#
#        it "list threads reactions" do
#          DisqusRails::Api::Threads.listReactions :thread => thread
#        end
#
#        it "subscribe to thread" do
#          DisqusRails::Api::Threads.subscribe :thread => thread
#        end
#
#        it "unsubscribe from thread" do
#          DisqusRails::Api::Threads.unsubscribe :thread => thread
#        end
#
#        it "vote for thread" do
#          DisqusRails::Api::Threads.vote :thread => thread, :vote => 1
#        end
#
#        it "updates thread" do
#          DisqusRails::Api::Threads.update(:thread => thread, :title => "new updated thread")
#        end
#
#        it "close thread" do
#          DisqusRails::Api::Threads.close(:thread => thread)
#        end
#
#        it "open thread" do
#          DisqusRails::Api::Threads.open(:thread => thread)
#        end
#
#        it "remove thread" do
#          DisqusRails::Api::Threads.remove(:thread => thread)
#        end
#
#        it "restore thread" do
#          DisqusRails::Api::Threads.restore(:thread => thread)
#        end
#
#        it "remove thread" do
#          DisqusRails::Api::Threads.remove(:thread => thread)
#        end
#      end
#    end
#  end
#
#  describe DisqusRails::Api::Users do
#    let(:user){15211395}
#
#    it "show user details" do
#      DisqusRails::Api::Users.details(:user => user)
#    end
#
#    it "follow" do
#      DisqusRails::Api::Users.follow(:target => 2)
#    end
#
#    it "unfollow" do
#      DisqusRails::Api::Users.unfollow(:target => 2)
#    end
#
#    it "change username" do
#      DisqusRails::Api::Users.checkUsername(:username => "stubbed_username")
#    end
#
#    it "list user active forums" do
#      DisqusRails::Api::Users.listActiveForums(:user => user)
#    end
#
#    it "list user forums" do
#      DisqusRails::Api::Users.listForums(:user => user)
#    end
#
#    it "list user most active forums" do
#      DisqusRails::Api::Users.listMostActiveForums(:user => user)
#    end
#
#    it "list user active threads" do
#      DisqusRails::Api::Users.listActiveThreads(:user => user)
#    end
#
#    it "list user activity" do
#      DisqusRails::Api::Users.listActivity(:user => user)
#    end
#
#    it "list user followers" do
#      DisqusRails::Api::Users.listFollowers(:user => user)
#    end
#
#    it "list user following" do
#      DisqusRails::Api::Users.listFollowing(:user => user)
#    end
#
#    it "list user posts" do
#      DisqusRails::Api::Users.listPosts(:user => user)
#    end
#  end
#
#  describe DisqusRails::Api::Forums do
#    it "show forum details" do
#      DisqusRails::Api::Forums.details(:forum => forum)
#    end
#
#    it "list forums categories" do
#      DisqusRails::Api::Forums.listCategories(:forum => forum)
#    end
#
#    it "list forum threads" do
#      DisqusRails::Api::Forums.listThreads(:forum => forum)
#    end
#
#    it "list forum users" do
#      DisqusRails::Api::Forums.listUsers(:forum => forum)
#    end
#
#    it "list forums moderators" do
#      DisqusRails::Api::Forums.listModerators(:forum => forum)
#    end
#
#    it "list forums most active users" do
#      DisqusRails::Api::Forums.listMostActiveUsers(:forum => forum)
#    end
#
#    it "list forums most liked users" do
#      DisqusRails::Api::Forums.listMostLikedUsers(:forum => forum)
#    end
#
#    it "list forum posts" do
#      DisqusRails::Api::Forums.listPosts(:forum => forum)
#    end
#  end
#
#  describe DisqusRails::Api::Categories do
#    let(:category){2388690}
#
#    it "list categories" do
#      DisqusRails::Api::Categories.list(:forum => forum)
#    end
#
#    it "create new category" do
#      result = DisqusRails::Api::Categories.create(:forum => forum, :title => "new category")
#      category = result[:response]["id"]
#
#      describe "in context of new created category" do
#
#        it "show category details" do
#          DisqusRails::Api::Categories.details(:category => category)
#        end
#
#        it "list category posts" do
#          DisqusRails::Api::Categories.listPosts(:category => category)
#        end
#
#        it "list category threads" do
#          DisqusRails::Api::Categories.listThreads(:category => category)
#        end
#      end
#    end
#  end
#
#end
