# frozen_string_literal: true

require_relative "lib/talkable/version"

Gem::Specification.new do |spec|
  spec.name        = "talkable"
  spec.version     = Talkable::VERSION
  spec.authors     = ["Talkable"]
  spec.email       = "dev@talkable.com"
  spec.description = "Talkable Ruby Gem to make your own referral program in Sinatra or Rails application"
  spec.license     = "MIT"

  spec.summary     = "Talkable Referral Program API"
  spec.homepage    = "https://github.com/talkable/talkable-ruby"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata = {
    "homepage_uri"      => spec.homepage,
    "bug_tracker_uri"   => "#{spec.homepage}/issues",
    "changelog_uri"     => "#{spec.homepage}/releases/tag/v#{spec.version}",
    "source_code_uri"   => "#{spec.homepage}/tree/v#{spec.version}",
    "allowed_push_host" => "https://rubygems.org",
    "rubygems_mfa_required" => "true",
  }

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "rack", "~> 2.2"
  spec.add_dependency "furi", "~> 0.2"
  spec.add_dependency "hashie", "~> 5.0"

  spec.add_development_dependency "rake", ">= 13.0"
  spec.add_development_dependency "rspec", ["~> 3", "< 3.11"]
  spec.add_development_dependency "simplecov", "~> 0.21"
  spec.add_development_dependency "webmock", "~> 3.14"

  spec.add_development_dependency "ammeter" # specs for generators
  spec.add_development_dependency "haml" # check haml syntax in generators
end
