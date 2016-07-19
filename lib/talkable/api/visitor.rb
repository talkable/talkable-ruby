module Talkable
  module API
    class Visitor < Base
      class << self
        def create(params = {})
          post '/visitors', {
            data: params,
          }
        end
      end
    end
  end
end
