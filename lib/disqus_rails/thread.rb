module Disqus
  class Thread < Model
    attr_accessor :id,
                  :title,
                  :identifiers,
                  :dislikes,
                  :isDeleted,
                  :userScore,
                  :isClosed,
                  :posts_count,
                  :link,
                  :likes,
                  :message,
                  :ipAddress,
                  :slug,
                  :createdAt,
                  :disqusable_id,
                  :feed,
                  :userSubscription,

                  :category,
                  :forum,
                  :reactions,
                  :author

    def initialize(attributes={})
      attributes.each do |attr_name, attr_value|
        if attr_name == "identifiers"
          unless attr_value.empty?
            instance_variable_set("@disqusable_id".to_sym, attr_value[0])
          end
        elsif attr_name == "posts"
          instance_variable_set("@posts_count".to_sym, attr_value)
        else
          instance_variable_set("@#{attr_name}".to_sym, attr_value)
        end
      end
    end

    def update_attributes(attributes={})
      attributes.each do |attr_name, attr_value|
        if attr_name == "identifiers"
          unless attr_value.empty?
            @disqusable_id = attr_value[0]
          end
        elsif attr_name == "posts"
          @posts_count = attr_value
        else
          send("#{attr_name}=", attr_value)
        end
      end
    end

    class << self
      def self.find_by_ids(attributes=[])
        Threads.new :Threads, :set, attributes
      end

      def self.hot(attributes)
        attributes[:forum] = forum
        Threads.new :Threads, :listHot, attributes
      end

      def self.popular(attributes)
        attributes[:forum] = forum
        Threads.new :Threads, :listPopular, attributes
      end

      def find_by_ident(disqusable_id)
        Disqus::Thread.where(:forum => Disqus::SHORT_NAME, :"thread:ident" => disqusable_id).first
      end
    end

    def posts(attributes={})
      attributes[:thread] = self.id
      Posts.new :Threads, :listPosts, attributes
    end

    def remove
      update_attributes Api::Threads.remove(:thread => self.id)[:response][0]
    end

    def create(attributes={})
      update_attributes Api::Threads.create(attributes)
    end

    def update(attributes={})
      attributes[:thread] = self.id
      update_attributes Api::Threads.update(attributes)[:response]
    end

    def open
      update_attributes Api::Threads.open(:thread => self.id)
    end

    def close
      update_attributes Api::Threads.close(:thread => self.id)
    end

    def restore
      update_attributes Api::Threads.restore(:thread => self.id)
    end

    def subscribe(email=nil)
      update_attributes Api::Threads.subscribe(:thread => self.id, :email => email)
    end

    def unsubscribe(email=nil)
      update_attributes Api::Threads.unsubscribe(:thread => self.id, :email => email)
    end

  end
end
