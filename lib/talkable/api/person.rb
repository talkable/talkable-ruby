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

        def unsubscribe(email_or_username)
          post "/people/#{email_or_username}/unsubscribe"
        end

        def anonymize(email_or_username)
          post "/people/#{email_or_username}/anonymize"
        end

        def personal_data(email_or_username)
          get "/people/#{email_or_username}/personal_data"
        end
      end
    end
  end
end
