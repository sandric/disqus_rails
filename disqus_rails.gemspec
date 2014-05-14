# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'disqus_rails/version'

Gem::Specification.new do |spec|
  spec.name          = "disqus_rails"
  spec.version       = DisqusRails::VERSION
  spec.authors       = ["Anton Kyrychenko"]
  spec.email         = ["kyrychenkoanton@gmail.com"]
  spec.description   = "Disqus 2012 Ruby on Rails wrapper"
  spec.summary       = "Integrates Disqus service into your Ruby on Rails application"
  spec.homepage      = "https://github.com/sandric/disqus_rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'sqlite3'

  spec.add_dependency "rails"
end
