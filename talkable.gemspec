$:.push File.expand_path('../lib', __FILE__)
require 'talkable/version'

Gem::Specification.new do |s|
  s.name        = "talkable"
  s.version     = Talkable::VERSION
  s.authors     = ["Talkable"]
  s.email       = "dev@talkable.com"
  s.description = "Talkable Ruby Gem to make your own referral program in Sinatra or Rails application"
  s.summary     = "Talkable Referral Program API"
  s.homepage    = "https://github.com/talkable/talkable-ruby"
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 2.3.0" # min ruby version that still receives security updates

  s.add_dependency "rack", ">= 1.6.1"
  s.add_dependency "furi", "~> 0.2"
  s.add_dependency "hashie", "~> 3.4"

  s.add_development_dependency "bundler", ">= 1.17.3"
  s.add_development_dependency "rake", "~> 11.2"
  s.add_development_dependency "rspec", "~> 3.4"
  s.add_development_dependency "simplecov", "~> 0.12"
  s.add_development_dependency "webmock", ">= 2.1"

  s.add_development_dependency "ammeter" # specs for generators
  s.add_development_dependency "haml" # check haml syntax in generators
end
