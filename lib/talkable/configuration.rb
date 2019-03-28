module Talkable
  class Configuration
    DEFAULT_SERVER = "https://www.talkable.com".freeze

    attr_accessor :site_slug
    attr_accessor :api_key
    attr_accessor :server
    attr_accessor :read_timeout
    attr_accessor :open_timeout
    attr_accessor :timeout
    attr_accessor :js_integration_library

    class UnknownOptionError < StandardError
    end

    def initialize
      self.site_slug    = ENV["TALKABLE_SITE_SLUG"]
      self.api_key      = ENV["TALKABLE_API_KEY"]
      self.server       = DEFAULT_SERVER
      self.read_timeout = 60
      self.open_timeout = 60
    end

    def apply(config)
      config.each do |key, value|
        if respond_to?("#{key}=")
          public_send("#{key}=", value)
        else
          raise UnknownOptionError.new("There is no `#{key}` option")
        end
      end
    end

    def js_integration_library
      @js_integration_library || default_js_integration_library
    end

    def clean
      self.site_slug    = nil
      self.api_key      = nil
      self.server       = DEFAULT_SERVER
      self.read_timeout = 60
      self.open_timeout = 60
    end

    def timeout=(sec)
      self.read_timeout = sec
      self.open_timeout = sec
    end

    protected

    def default_js_integration_library
      "//d2jjzw81hqbuqv.cloudfront.net/integration/clients/#{site_slug}.min.js"
    end
  end
end
