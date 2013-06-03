module Disqus
  class Post < Model
    attr_accessor :id,
                  :isJuliaFlagged,
                  :isFlagged,
                  :parent,
                  :media,
                  :isApproved,
                  :dislikes,
                  :raw_message,
                  :points,
                  :createdAt,
                  :isEdited,
                  :message,
                  :isHighlighted,
                  :ipAddress,
                  :isSpam,
                  :isDeleted,
                  :likes,

                  :author,
                  :thread,
                  :forum

    class << self

      def popular(attributes={})
        Posts.new :Posts, :listPopular, attributes
      end

    end

    def update(message)
      update_attributes Api::Posts.approve(:post => self.id, :message => message)
    end

    def remove
      update_attributes Api::Posts.remove(:post => self.id)
    end

    def restore
      update_attributes Api::Posts.restore(:post => self.id)
    end

    def approve
      update_attributes Api::Posts.approve(:post => self.id)
    end

    def getContext(depth = nil, related = nil)
      update_attributes Api::Posts.getContext(:post => self.id, :depth => depth, :related => related)
    end

    def spam
      update_attributes Api::Posts.spam(:post => self.id)
    end

    def report
      update_attributes Api::Posts.report(:post => self.id)
    end

    def highlight
      update_attributes Api::Posts.highlight(:post => self.id)
    end

    def unhighlight
      update_attributes Api::Posts.unhighlight(:post => self.id)
    end

    def vote(vote)
      update_attributes Api::Posts.vote(:post => self.id, :vote => vote)
    end

  end
end
