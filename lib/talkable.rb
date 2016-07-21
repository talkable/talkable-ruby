require 'talkable/version'
require 'talkable/configuration'
require 'talkable/api'
require 'talkable/middleware'

module Talkable
  UUID = 'talkable_visitor_uuid'.freeze

  class << self
    def configure(config = nil)
      configuration.apply config if config
      yield(configuration) if block_given?
    end

    def configuration
      @configuration ||= Talkable::Configuration.new
    end

    def visitor_uuid
      Thread.current[UUID]
    end

    def visitor_uuid=(uuid)
      Thread.current[UUID] = uuid
    end

    def with_uuid(uuid)
      old_uuid, Talkable.visitor_uuid = Talkable.visitor_uuid, uuid
      yield if block_given?
    ensure
      Talkable.visitor_uuid = old_uuid
    end

    def find_or_generate_uuid
      visitor_uuid || Talkable::API::Visitor.create[:uuid]
    end

  end

end
