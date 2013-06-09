module DisqusRails
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

    def initialize(attributes={})
      attributes.each do |attr_name, attr_value|
        if attr_name == "author"
          @author = DisqusRails::User.new(attr_value)
        else
          instance_variable_set("@#{attr_name}".to_sym, attr_value)
        end
      end
    end

    def update(message)
      update_attributes Api::Posts.update(:post => self.id, :message => message)[:response]
    end

    def remove
      if Api::Posts.remove(:post => self.id)
        update_attributes :isDeleted => true
      end
    end

    def restore
      if Api::Posts.restore(:post => self.id)
        update_attributes :isDeleted => false
      end
    end

    def approve
      if Api::Posts.approve(:post => self.id)
        update_attributes :isApproved => true
      end
    end

    def getContext(depth = nil, related = nil)
      update_attributes Api::Posts.getContext(:post => self.id, :depth => depth, :related => related)
    end

    def spam
      if Api::Posts.spam(:post => self.id)
        update_attributes :isSpam => true
      end
    end

    def report
      if Api::Posts.report(:post => self.id)
        update_attributes :isFlagged => true
      end
    end

    def highlight
      if Api::Posts.highlight(:post => self.id)
        update_attributes :isHighlighted => true
      end
    end

    def unhighlight
      if Api::Posts.unhighlight(:post => self.id)
        update_attributes :isHighlighted => false
      end
    end

    def vote=(vote)
      @vote = vote
    end
    def vote(*args)
      if args.empty?
        @vote
      else
        if Api::Posts.vote(:post => self.id, :vote => args.first)
          update_attributes :vote => args.first
        end
      end
    end
  end
end
