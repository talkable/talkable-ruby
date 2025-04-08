require 'net/https'
require 'json'
require 'furi'

module Talkable
  module API
    class Base
      class << self
        def get(path, params = {})
          uri = request_uri(path, request_params(params))
          request = Net::HTTP::Get.new(uri.request_uri)
          perform_request(uri, request)
        end

        def post(path, params = {})
          data_request(:post, path, params)
        end

        def put(path, params = {})
          data_request(:put, path, params)
        end

        protected

        def data_request(method, path, params)
          http_class = {post: Net::HTTP::Post, put: Net::HTTP::Put}[method.to_sym]
          uri = request_uri(path)
          request = http_class.new(uri.request_uri)
          request.body = request_params(params).to_json
          perform_request(uri, request)
        end

        def request_params(params = {})
          params.merge({
            site_slug: Talkable.configuration.site_slug,
          })
        end

        def request_uri(path, params = {})
          URI(
            Furi.update("#{Talkable.configuration.server}/api/#{Talkable::API::VERSION}#{path}",
              query: params
            )
          )
        end

        def request_headers
          {
            'User-Agent'    => "Talkable Gem/#{Talkable::VERSION}",
            'Content-Type'  => 'application/json',
            'Accept'        => 'application/json',
            'Authorization' => "Bearer #{Talkable.configuration.api_key}",
          }
        end

        def perform_request(uri, request)
          http = Net::HTTP.new(uri.host, uri.port)
          http.read_timeout = Talkable.configuration.read_timeout
          http.open_timeout = Talkable.configuration.open_timeout
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
          result = JSON.parse(body, symbolize_names: true)
          raise_invalid_response unless result.is_a?(Hash)

          if result[:ok]
            result[:result]
          else
            raise BadRequest.new(result[:error_message])
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
