require 'talkable/version'
require 'talkable/configuration'
require 'talkable/api'
require 'talkable/resources'
require 'talkable/middleware'
require 'talkable/integration'
require 'talkable/railtie' if defined? ::Rails::Railtie

module Talkable
  UUID = 'talkable_visitor_uuid'.freeze
  CURRENT_URL = 'talkable_current_url'.freeze

  class << self
    def configure(config = nil)
      configuration.apply config if config
      yield(configuration) if block_given?
    end

    def configuration
      @configuration ||= Talkable::Configuration.new
    end

    def reset_configuration
      configuration.reset
    end

    def visitor_uuid
      Thread.current[UUID]
    end

    def visitor_uuid=(uuid)
      Thread.current[UUID] = uuid
    end

    def find_or_generate_uuid
      visitor_uuid || Talkable::API::Visitor.create[:uuid]
    end

    def current_url
      Thread.current[CURRENT_URL]
    end

    def current_url=(url)
      Thread.current[CURRENT_URL] = url
    end

    def with_uuid_and_url(uuid, url)
      old_url, Talkable.current_url = Talkable.current_url, url
      old_uuid, Talkable.visitor_uuid = Talkable.visitor_uuid, uuid
      yield if block_given?
    ensure
      Talkable.current_url = old_url
      Talkable.visitor_uuid = old_uuid
    end
  end
end
