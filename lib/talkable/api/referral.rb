module Talkable
  module API
    class Referral < Base
      APPROVED  = "approved".freeze
      VOIDED    = "voided".freeze
      UNBLOCKED = "unblocked".freeze

      class << self
        def update(origin_slug, status)
          put "/origins/#{origin_slug}/referral", {
            data: {
              status: status
            }
          }
        end
      end
    end
  end
end
