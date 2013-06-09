module DisqusRails
  module Disqusable
    module ActiveRecordMethods
      def acts_as_disqusable
        include ActsAsDisqusable
      end
    end

    module ActsAsDisqusable

      def disqus_thread
        DisqusRails::Thread.find_by_ident(self.id)
      end

      def self.included(disqusable)
        Thread.class_exec do
          define_method :disqusable do
            disqusable.find(@disqusable_id)
          end
        end
      end
    end
  end
end
