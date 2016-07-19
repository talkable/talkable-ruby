require 'talkable/api/base'
require 'talkable/api/origin'
require 'talkable/api/offer'
require 'talkable/api/visitor'

module Talkable
  module API
    VERSION = "v2"
    class BadRequest < StandardError
    end
    class NetworkError < StandardError
    end
  end
end
