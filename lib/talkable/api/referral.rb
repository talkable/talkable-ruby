module Talkable
  module API
    class Referral < Base
      APPROVED  = 'approved'
      VOIDED    = 'voided'
      UNBLOCKED = 'unblocked'

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
