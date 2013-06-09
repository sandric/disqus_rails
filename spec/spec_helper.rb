require 'rubygems'
require 'bundler/setup'

require 'rails/all'
require 'disqus_rails'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)

RSpec.configure do |config|
end
