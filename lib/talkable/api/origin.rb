module Talkable
  module API
    class Origin < Base
      AFFILIATE_MEMBER  = "AffiliateMember".freeze
      PURCHASE          = "Purchase".freeze
      EVENT             = "Event".freeze

      class << self
        def create(origin_type, params)
          post '/origins', {
            type: origin_type,
            data: params,
          }
        end
      end
    end
  end
end
