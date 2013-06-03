module DisqusRails
  module Disquser
    class Railtie < Rails::Railtie
      initializer 'acts_as_disquser.extend_active_record' do
        ::ActiveRecord::Base.extend ActiveRecordMethods
      end
    end

    module ActiveRecordMethods
      def acts_as_disquser(attributes={})

        define_method :disqus_params do
          data = {}

          if attributes.has_key?(:id)
            if attributes[:id].is_a? Proc
              data[:id] = instance_eval &attributes[:id]
            else
              data[:id] = send attributes[:id]
            end
          else
            data[:id] = self.id
          end

          if attributes.has_key?(:username)
            if attributes[:username].is_a? Proc
              data[:username] = instance_eval &attributes[:username]
            else
              data[:username] = send attributes[:username]
            end
          end

          if attributes.has_key?(:email)
            if attributes[:email].is_a? Proc
              data[:email] = instance_eval &attributes[:email]
            else
              data[:email] = send attributes[:email]
            end
          end

          if attributes.has_key?(:avatar)
            if attributes[:avatar].is_a? Proc
              data[:avatar] = instance_eval &attributes[:avatar]
            else
              data[:avatar] = send attributes[:avatar]
            end
          end

          data
        end
      end
    end
  end
end
