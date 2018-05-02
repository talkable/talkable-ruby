module Talkable
  module API
    class Origin < Base
      AFFILIATE_MEMBER  = "AffiliateMember".freeze
      PURCHASE          = "Purchase".freeze
      EVENT             = "Event".freeze

      DEFAULT_TRAFFIC_SOURCE = 'talkable-gem'

      class << self
        def create(origin_type, params)
          post '/origins', {
            type: origin_type,
            data: default_data.merge(params),
          }
        end

        protected

        def default_data
          {
            traffic_source: DEFAULT_TRAFFIC_SOURCE,
          }
        end
      end
    end
  end
end
