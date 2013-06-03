module DisqusRails
  class Category < Model
    attr_accessor :id
                  :title
                  :order
                  :isDefault

                  :category

    class << self
      def popular(attributes={})
        Categories.new :Categories, :listPopular, attributes
      end
    end

    def threads(attributes={})
      attributes[:category] = self.id
      Threads.new :Categories, :listThreads, attributes
    end

    def posts(attributes={})
      attributes[:category] = self.id
      Posts.new :Categories, :listPosts, attributes
    end
    
  end
end
