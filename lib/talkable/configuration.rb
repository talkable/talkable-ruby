module Talkable
  class Configuration
    DEFAULT_SERVER = "https://www.talkable.com".freeze

    attr_accessor :site_slug
    attr_accessor :api_key
    attr_accessor :server
    attr_accessor :js_integration_host

    class UnknownOptionError < StandardError
    end

    def initialize
      self.site_slug           = ENV["TALKABLE_SITE_SLUG"]
      self.api_key             = ENV["TALKABLE_API_KEY"]
      self.server              = "https://www.talkable.com"
      self.js_integration_host = "d2jjzw81hqbuqv.cloudfront.net"
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
      "//#{js_integration_host}/integration/clients/#{site_slug}.min.js"
    end
  end
end
