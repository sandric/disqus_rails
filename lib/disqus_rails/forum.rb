module DisqusRails
  class Forum < Model
    attr_accessor :id,
                  :name,
                  :favicon,

                  :founder

    class << self
      def popular(attributes={})
        Forums.new :Forums, :listPopular, attributes
      end
    end

    def categories(attributes={})
      attributes[:forum] = self.id
      Categories.new :Forums, :listCategories, attributes
    end

    def threads(attributes={})
      attributes[:forum] = self.id
      Threads.new :Forums, :listThreads, attributes
    end

    def posts(attributes={})
      attributes[:forum] = self.id
      Posts.new :Forums, :listPosts, attributes
    end

    def users(attributes={})
      attributes[:forum] = self.id
      Users.new :Forums, :listUsers, attributes
    end

    def most_active_users(attributes={})
      attributes[:forum] = self.id
      Users.new :Forums, :listMostActiveUsers, attributes
    end

    def most_liked_users(attributes={})
      attributes[:forum] = self.id
      Users.new :Forums, :listMostLikedUsers, attributes
    end

    def add_moderator(user_id)
      update_attributes Api::Forums.add_moderator(:forum => self.id, :user => user_id)
    end

    def remove_moderator(user_id)
      update_attributes Api::Forums.remove_moderator(:user => user_id)
    end

  end
end
