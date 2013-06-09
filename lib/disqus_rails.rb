require "disqus_rails/version"

%w[api helpers collection model user post thread forum category].each do |file|
  require File.join(File.dirname(__FILE__), "disqus_rails", file)
end

%w[acts_as_disqusable acts_as_disquser].each do |file|
  require File.join(File.dirname(__FILE__), "disqus_rails/active_record", file)
end

module DisqusRails
  module Rails
    class Engine < ::Rails::Engine
      initializer 'acts_as_disqusable.extend_active_record' do
        ::ActiveRecord::Base.extend DisqusRails::Disqusable::ActiveRecordMethods
      end

      initializer 'acts_as_disquser.extend_active_record' do
        ::ActiveRecord::Base.extend DisqusRails::Disquser::ActiveRecordMethods
      end
    end
  end

  def self.setup
    yield self
  end
end

module ApplicationHelper
  include DisqusRails::Helpers
end
