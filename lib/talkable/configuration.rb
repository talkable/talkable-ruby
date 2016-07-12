module Talkable
  class Configuration
    attr_accessor :site_slug
    attr_accessor :api_key
    attr_accessor :server
    attr_accessor :js_integration_library

    def initialize
      self.site_slug  = ENV["TALKABLE_SITE_SLUG"]
      self.api_key    = ENV["TALKABLE_API_KEY"]
      self.server     = "https://talkable.com"
    end

    def apply(config)
      config.each do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
    end

    def js_integration_library
      @js_integration_library || default_js_integration_library
    end

    protected

    def default_js_integration_library
      "//d2jjzw81hqbuqv.cloudfront.net/integration/clients/#{site_slug}.min.js"
    end

  end
end
