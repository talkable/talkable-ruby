require 'talkable/version'
require 'talkable/configuration'
require 'talkable/api'

module Talkable

  class << self
    attr_reader :visitor_uuid

    def configure(config = nil)
      configuration.apply config if config
      yield(configuration) if block_given?
    end

    def configuration
      @configuration ||= Talkable::Configuration.new
    end

    def with_uuid(uuid)
      old_uuid, @visitor_uuid = @visitor_uuid, uuid
      result = yield if block_given?
      @visitor_uuid = old_uuid
      result
    end

    def find_or_generate_uuid
      visitor_uuid || Talkable::API::Visitor.create[:uuid]
    end

  end

end
