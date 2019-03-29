module Talkable
  module API
    class Campaign < Base
      class << self
        def all
          get "/campaigns"
        end
      end
    end
  end
end
