module Talkable
  class Configuration
    DEFAULT_SERVER  = 'https://www.talkable.com'.freeze
    DEFAULT_TIMEOUT = 5

    attr_accessor :site_slug
    attr_accessor :api_key
    attr_accessor :server
    attr_accessor :read_timeout
    attr_accessor :open_timeout
    attr_accessor :js_integration_library

    class UnknownOptionError < StandardError
    end

    def initialize
      apply(default_configuration)
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

    def reset
      apply(default_configuration)
    end

    def timeout=(sec)
      apply(read_timeout: sec, open_timeout: sec)
    end

    private

    def default_js_integration_library
      "//d2jjzw81hqbuqv.cloudfront.net/integration/clients/#{site_slug}.min.js"
    end

    def default_configuration
      {
        site_slug:              ENV["TALKABLE_SITE_SLUG"],
        api_key:                ENV["TALKABLE_API_KEY"],
        server:                 DEFAULT_SERVER,
        read_timeout:           DEFAULT_TIMEOUT,
        open_timeout:           DEFAULT_TIMEOUT,
        js_integration_library: nil
      }
    end
  end
end
