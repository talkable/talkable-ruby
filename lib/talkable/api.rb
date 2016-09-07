require 'talkable/api/base'
require 'talkable/api/person'
require 'talkable/api/origin'
require 'talkable/api/offer'
require 'talkable/api/share'
require 'talkable/api/reward'
require 'talkable/api/visitor'
require 'talkable/api/referral'

module Talkable
  module API
    VERSION = "v2".freeze
    class BadRequest < StandardError
    end
    class NetworkError < StandardError
    end
  end
end
