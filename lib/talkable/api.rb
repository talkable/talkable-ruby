require 'talkable/api/base'

Dir[File.dirname(__FILE__) + '/api/*.rb'].each { |file| require file }

module Talkable
  module API
    VERSION = "v2".freeze
    class BadRequest < StandardError
    end
    class NetworkError < StandardError
    end
  end
end
