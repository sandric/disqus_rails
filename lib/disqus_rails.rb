require "disqus_rails/version"

%w[api helpers collection model user post thread forum category].each do |file|
  require File.join(File.dirname(__FILE__), "disqus_rails", file)
end

%w[acts_as_disqusable acts_as_disquser].each do |file|
  require File.join(File.dirname(__FILE__), "disqus_rails/active_record", file)
end

module DisqusRails
  def self.setup
    yield self
  end
end

module ApplicationHelper
  include Disqus::Helpers
end
