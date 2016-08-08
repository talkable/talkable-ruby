require 'rack/request'

module Talkable
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      uuid = talkable_visitor_uuid(env)

      result = Talkable.with_uuid(uuid) do
        @app.call(env)
      end

      inject_uuid_in_cookie(uuid, result)
      inject_uuid_in_body(uuid, result)
    end

    protected

    def talkable_visitor_uuid(env)
      req = Rack::Request.new(env)
      req.params[UUID] || req.cookies[UUID] || Talkable.find_or_generate_uuid
    end

    def inject_uuid_in_cookie(uuid, result)
      Rack::Utils.set_cookie_header!(result[1], UUID, {value: uuid, path: '/', expires: cookies_expiration})
    end

    def inject_uuid_in_body(uuid, result)
      return result unless inject_body?(result)

      body = result[2]
      body_content = collect_response(body)
      body.close if body.respond_to?(:close)

      if injection_index = body_injection_position(body_content)
        body_content = \
          body_content[0...injection_index] \
          << sync_uuid_content(uuid) \
          << body_content[injection_index..-1]
      end

      if body_content
        response = Rack::Response.new(body_content, result[0], result[1])
        response.finish
      else
        result
      end
    end

    def cookies_expiration
      Time.now + (20 * 365 * 24 * 60 * 60) # 20 years
    end

    def sync_uuid_url(uuid)
      "https://www.talkable.com/public/1x1.gif?current_visitor_uuid=#{URI.escape(uuid)}"
    end

    def sync_uuid_content(uuid)
      "\n<img src=\"#{sync_uuid_url(uuid)}\" style=\"position:absolute; left:-9999px;\" alt=\"\" />"
    end

    def inject_body?(result)
      status, headers = result
      status == 200 && html?(headers) && !attachment?(headers)
    end

    def collect_response(body)
      content = nil
      if body.respond_to?(:each)
        body.each do |chunk|
          content ? (content << chunk.to_s) : (content = chunk.to_s)
        end
      else
        content = body
      end
      content
    end

    def body_injection_position(content)
      pattern = /<\s*body[^>]*>/im
      match = pattern.match(content)
      match.end(0) if match
    end

    def html?(headers)
      content_type = headers['Content-Type']
      content_type && content_type.include?('text/html')
    end

    def attachment?(headers)
      content_disposition = headers['Content-Disposition']
      content_disposition && content_disposition.include?('attachment')
    end

  end
end
