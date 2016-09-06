module Talkable
  module API
    class Share < Base
      CHANNEL_FACEBOOK          = "facebook".freeze
      CHANNEL_FACEBOOK_MESSAGE  = "facebook_message".freeze
      CHANNEL_TWITTER           = "twitter".freeze
      CHANNEL_SMS               = "sms".freeze
      CHANNEL_OTHER             = "other".freeze

      class << self
        def create(short_url_code, channel)
          post "/offers/#{short_url_code}/shares", {
            channel: channel,
          }
        end
      end
    end
  end
end
