module Talkable
  module API
    class Person < Base
      class << self
        def find(email_or_username)
          get "/people/#{email_or_username}"
        end

        def update(email_or_username, params)
          put "/people/#{email_or_username}", {
            data: params
          }
        end
      end
    end
  end
end
