module Talkable
  class << self
    def register_affiliate_member(params = {})
      register_origin(Talkable::API::Origin::AFFILIATE_MEMBER, params)
    end

    def register_purchase(params = {})
      register_origin(Talkable::API::Origin::PURCHASE, params)
    end

    def register_event(params = {})
      register_origin(Talkable::API::Origin::EVENT, params)
    end

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

    def register_origin(origin_type, params = {})
      origin_params = default_params.merge(params)
      result = Talkable::API::Origin.create(origin_type, origin_params)
      origin = Talkable::Origin.parse(result)
      origin
    end

    def default_params
      {
        uuid: Talkable.visitor_uuid,
        r: Talkable.current_url,
      }
    end
  end
end
