module Disqus
  module Disqusable
    class Railtie < Rails::Railtie
      initializer 'acts_as_disqusable.extend_active_record' do
        ::ActiveRecord::Base.extend ActiveRecordMethods
      end
    end

    module ActiveRecordMethods
      def acts_as_disqusable
        include ActsAsDisqusable
      end
    end

    module ActsAsDisqusable

      def disqus_thread
        Disqus::Thread.find_by_ident(self.id)
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
