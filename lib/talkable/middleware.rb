require 'cgi'
require 'rack/request'

module Talkable
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      uuid = talkable_visitor_uuid(request)

      result = Talkable.with_uuid(uuid) do
        Talkable.with_request_url(request.url) do
          @app.call(env)
        end
      end

      inject_uuid_in_cookie(uuid, result)
      modify_response_content(result) do |content|
        content = inject_uuid_in_body(uuid, content)
        inject_integration_js_in_head(content)
      end

    end

    protected

    def talkable_visitor_uuid(request)
      request.params[UUID] || request.cookies[UUID] || Talkable.find_or_generate_uuid
    end

    def inject_uuid_in_cookie(uuid, result)
      Rack::Utils.set_cookie_header!(result[1], UUID, {value: uuid, path: '/', expires: cookies_expiration})
    end

    def modify_response_content(result)
      return result unless modifiable?(result)

      status, header, body = result
      response_content = collect_content(body)
      body.close if body.respond_to?(:close)

      response_content = yield(response_content) if block_given?

      if response_content
        response = Rack::Response.new(response_content, status, header)
        response.finish
      else
        result
      end
    end

    def inject_uuid_in_body(uuid, content)
      if injection_index = body_injection_position(content)
        content = inject_in_content(content, sync_uuid_content(uuid), injection_index)
      end
      content
    end

    def inject_integration_js_in_head(content)
      if injection_index = head_injection_position(content)
        content = inject_in_content(content, integration_content, injection_index)
      end
      content
    end

    def inject_in_content(content, injection, position)
      content[0...position] << injection << content[position..-1]
    end

    def cookies_expiration
      Time.now + (20 * 365 * 24 * 60 * 60) # 20 years
    end

    def sync_uuid_url(uuid)
      Furi.update("https://www.talkable.com/public/1x1.gif", query: {current_visitor_uuid: uuid})
    end

    def sync_uuid_content(uuid)
      src = CGI.escape_html(sync_uuid_url(uuid))
      %Q{
<img src="#{src}" style="position:absolute; left:-9999px;" alt="" />
      }
    end

    def integration_content
      integration_init_content + integration_script_content
    end

    def integration_init_content
      %Q{
<script>
  window._talkableq = window._talkableq || [];
  _talkableq.push(['init', #{init_parameters.to_json}]);
</script>
      }
    end

    def init_parameters
      {
        site_id: Talkable.configuration.site_slug,
        server: Talkable.configuration.server,
      }
    end

    def integration_script_content
      src = CGI.escape_html(Talkable.configuration.js_integration_library)
      %Q{
<script src="#{src}" type="text/javascript"></script>
      }
    end

    def modifiable?(result)
      status, headers = result
      status == 200 && html?(headers) && !attachment?(headers)
    end

    def collect_content(chunks)
      ''.tap do |content|
        chunks.each { |chunk| content << chunk.to_s }
      end
    end

    def body_injection_position(content)
      pattern = /<\s*body[^>]*>/im
      match = pattern.match(content)
      match.end(0) if match
    end

    def head_injection_position(content)
      pattern = /<\s*\/\s*head[^>]*>/im
      match = pattern.match(content)
      match.begin(0) if match
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
