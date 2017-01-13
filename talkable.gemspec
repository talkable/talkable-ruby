$:.push File.expand_path('../lib', __FILE__)
require 'talkable/version'

Gem::Specification.new do |s|
  s.name        = "talkable"
  s.version     = Talkable::VERSION
  s.date        = Date.today.to_s
  s.summary     = "Talkable Referral Program API"
  s.description = "Talkable Ruby Gem to make your own referral program in Sinatra or Rails application"
  s.authors     = ["Talkable"]
  s.email       = "dev@talkable.com"
  s.homepage    = "https://github.com/talkable/talkable-ruby"
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 1.9.3"

  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.1.0")
    s.add_dependency "nokogiri", "< 1.7.0"
  end

  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.2.2")
    s.add_dependency "rack", ">= 1.5.2", "< 2"
  else
    s.add_dependency "rack", ">= 1.5.2"
  end

  s.add_dependency "furi", "~> 0.2"
  s.add_dependency "hashie", "~> 3.4"

  s.add_development_dependency "bundler", "~> 1.12"
  s.add_development_dependency "rake", "~> 11.2"
  s.add_development_dependency "rspec", "~> 3.4"
  s.add_development_dependency "simplecov", "~> 0.12"

  if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.0")
    s.add_development_dependency "json", "~> 1.8.3"
    s.add_development_dependency "webmock", ">= 2.1", "< 2.3"
  else
    s.add_development_dependency "webmock", ">= 2.1"
  end

  s.add_development_dependency "ammeter" # specs for generators
  s.add_development_dependency "haml" # check haml syntax in generators
end
