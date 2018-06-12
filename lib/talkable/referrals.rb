module Talkable
  class << self
    def approve_referral(origin_slug)
      update_referral(origin_slug, Talkable::API::Referral::APPROVED)
    end

    def void_referral(origin_slug)
      update_referral(origin_slug, Talkable::API::Referral::VOIDED)
    end

    def unblock_referral(origin_slug)
      update_referral(origin_slug, Talkable::API::Referral::UNBLOCKED)
    end

    private

    def update_referral(origin_slug, status)
      Talkable::API::Referral.update(origin_slug, status)
    end
  end
end
