# More at http://docs.talkable.com/api_v2/shares.html
module Talkable
  module API
    class Share < Base
      # social
      VIA_FACEBOOK    = "facebook"
      VIA_FB_MESSAGE  = "facebook_message"
      VIA_TWITTER     = "twitter"
      VIA_LINKEDIN    = "linkedin"
      VIA_WHATSAPP    = "twitter"
      VIA_SMS         = "sms"
      VIA_OTHER       = "other"

      # direct
      SEND_EMAIL      = "email"

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
