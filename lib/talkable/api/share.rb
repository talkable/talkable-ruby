# More at http://docs.talkable.com/api_v2/shares.html
module Talkable
  module API
    class Share < Base
      # social
      VIA_FACEBOOK    = "facebook".freeze
      VIA_FB_MESSAGE  = "facebook_message".freeze
      VIA_TWITTER     = "twitter".freeze
      VIA_LINKEDIN    = "linkedin".freeze
      VIA_WHATSAPP    = "whatsapp".freeze
      VIA_SMS         = "sms".freeze
      VIA_OTHER       = "other".freeze

      # direct
      SEND_EMAIL      = "email".freeze

      class << self
        def create(short_url_code, channel)
          warn "[DEPRECATION] `create` is deprecated.  Please use `social` or `direct` instead."
          social(short_url_code, channel: channel)
        end

        def social(short_url_code, channel:)
          post "/offers/#{short_url_code}/shares/social", {
            channel: channel,
          }
        end

        def direct(short_url_code, channel: SEND_EMAIL, recipients:, subject: nil, body: nil, reminder: nil)
          raise ArgumentError, 'Email is the only supported sharing channel' unless channel == SEND_EMAIL
          post "/offers/#{short_url_code}/shares/#{channel}", {
            recipients: recipients,
            subject: subject,
            body: body,
            reminder: reminder,
          }
        end
      end
    end
  end
end
