module Talkable
  module API
    class Reward < Base
      class << self
        def find(params = {})
          get "/rewards", default_params.merge(params)
        end

        protected

        def default_params
          {
            visitor_uuid: Talkable.visitor_uuid,
          }
        end
      end
    end
  end
end
