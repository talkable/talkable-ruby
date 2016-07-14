require 'net/https'
require 'json'

module Talkable
  module API
    class Base
      class << self
        def get(path, params = nil)
          uri = request_uri(path, request_params(params))
          request = Net::HTTP::Get.new(uri.request_uri)
          perform_request(uri, request)
        end

        def post(path, params = nil)
          uri = request_uri(path)
          request = Net::HTTP::Post.new(uri.request_uri)
          request.body = request_params(params).to_json
          perform_request(uri, request)
        end

        protected

        def request_params(params = nil)
          (params || {}).merge({
            api_key:   Talkable.configuration.api_key,
            site_slug: Talkable.configuration.site_slug,
          })
        end

        def request_uri(path, params = nil)
          uri = URI("#{Talkable.configuration.server}/api/#{Talkable::API::VERSION}#{path}")
          uri.query = URI.encode_www_form(params) if params
          uri
        end

        def request_headers
          {
            'User-Agent'    => "Talkable Gem/#{Talkable::VERSION}",
            'Content-Type'  => 'application/json',
            'Accept'        => 'application/json',
          }
        end

        def perform_request(uri, request)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.is_a?(URI::HTTPS)

          request.initialize_http_header request_headers
          process_response http.request(request)
        rescue  Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT,
                Errno::EHOSTUNREACH, Errno::ENETUNREACH, SocketError, Timeout::Error,
                OpenSSL::SSL::SSLError, EOFError, Net::HTTPBadResponse => e
          raise NetworkError.new(e.message)
        end

        def process_response(response)
          case response
          when Net::HTTPSuccess, Net::HTTPClientError
            parse_response response.body
          when Net::HTTPServerError
            raise NetworkError.new("Server #{Talkable.configuration.server} is unavailable. Try again later")
          end
        end

        def parse_response(body)
          raise_invalid_response if body.nil?
          result = JSON.parse(body)
          raise_invalid_response unless result.is_a?(Hash)

          if result['ok']
            result['result']
          else
            raise BadRequest.new(result['error_message'])
          end

        rescue JSON::ParserError
          raise_invalid_response
        end

        def raise_invalid_response
          raise BadRequest.new("Invalid response")
        end
      end
    end
  end
end
