module Talkable
  module API
    class Offer < Base
      class << self
        def find(id, params = {})
          get "/offers/#{id}", params
        end
      end
    end
  end
end
