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

    private

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
