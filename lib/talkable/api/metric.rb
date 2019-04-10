module Talkable
  module API
    class Metric < Base
      class << self
        def find(name, params = {})
          get "/metrics/#{name}", params
        end
      end
    end
  end
end
