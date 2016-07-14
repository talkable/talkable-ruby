require 'talkable/api/base'
require 'talkable/api/origins'

module Talkable
  module API
    VERSION = "v2"
    class BadRequest < StandardError
    end
    class NetworkError < StandardError
    end
  end
end
