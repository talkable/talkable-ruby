require 'rack/request'

module Talkable
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      uuid = talkable_visitor_uuid(env)

      status, headers, body = Talkable.with_uuid(uuid) do
        @app.call(env)
      end

      Rack::Utils.set_cookie_header!(headers, UUID, {value: uuid, path: '/', expires: cookies_expiration})

      [status, headers, body]
    end

    protected

    def talkable_visitor_uuid(env)
      req = Rack::Request.new(env)
      req.params[UUID] || req.cookies[UUID] || Talkable.find_or_generate_uuid
    end

    def cookies_expiration
      Time.now + (20 * 365 * 24 * 60 * 60) # 20 years
    end
  end
end
