require 'talkable/version'
require 'talkable/configuration'

module Talkable

  class << self
    def configure(config = nil)
      configuration.apply config if config
      yield(configuration) if block_given?
    end

    def configuration
      @configuration ||= Talkable::Configuration.new
    end
  end

end
