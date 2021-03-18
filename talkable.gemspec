$:.push File.expand_path('../lib', __FILE__)
require 'talkable/version'

Gem::Specification.new do |spec|
  spec.name        = "talkable"
  spec.version     = Talkable::VERSION
  spec.authors     = ["Talkable"]
  spec.email       = "dev@talkable.com"
  spec.description = "Talkable Ruby Gem to make your own referral program in Sinatra or Rails application"
  spec.license     = "MIT"

  spec.summary     = "Talkable Referral Program API"
  spec.homepage    = "https://github.com/talkable/talkable-ruby"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
    spec.metadata["homepage_uri"]      = spec.homepage
    spec.metadata["source_code_uri"]   = spec.homepage
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files`.split("\n").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.5.0" # min ruby version that still receives security updates

  spec.add_dependency "rack", ">= 1.6.1"
  spec.add_dependency "furi", "~> 0.2"
  spec.add_dependency "hashie", "~> 3.5", ">= 3.5.2"

  spec.add_development_dependency "bundler", ">= 1.15.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency "simplecov", "~> 0.21"
  spec.add_development_dependency "webmock", "~> 3.8"

  spec.add_development_dependency "ammeter" # specs for generators
  spec.add_development_dependency "haml" # check haml syntax in generators
end
