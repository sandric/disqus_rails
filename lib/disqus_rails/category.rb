module DisqusRails
  class Category < Model
    attr_accessor :id
                  :title
                  :order
                  :isDefault

                  :category

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
