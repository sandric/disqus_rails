module DisqusRails
  class User < Model
    attr_accessor :id,
                  :username,
                  :about,
                  :name,
                  :url,
                  :isFollowing,
                  :isFollowedBy,
                  :profileUrl,
                  :emailHash,
                  :avatar,
                  :isAnonymous,
                  :email,
                  :disquser_id

    class << self

      def popular(attributes={})
        Users.new :Threads, :listPopular, attributes
      end

    end

    def change_name(name)
      Api::Users.checkUsername(:user => self.id, :username => name)
    end

    def follow(target_id)
      Api::Users.follow(:user => self.id, :target => target_id)
    end

    def unfollow(target_id)
      Api::Users.unfollow(:user => self.id, :target => target_id)
    end


    def forums(attributes={})
      attributes[:user] = self.id
      Forums.new :Users, :listForums, attributes
    end

    def active_forums(attributes={})
      attributes[:user] = self.id
      Forums.new :Users, :listActiveForums, attributes
    end

    def active_threads(attributes={})
      attributes[:user] = self.id
      Threads.new :Users, :listActiveThreads, attributes
    end

    def posts(attributes={})
      attributes[:user] = self.id
      Posts.new :Users, :listPosts, attributes
    end

    def followers(attributes={})
      attributes[:user] = self.id
      Users.new :Users, :listFollowers, attributes
    end

    def following(attributes={})
      attributes[:user] = self.id
      Users.new :Users, :listFollowing, attributes
    end
  end
end
