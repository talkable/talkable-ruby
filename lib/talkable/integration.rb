module Talkable
  DEFAULT_CAMPAIGN_TAGS = {
    Talkable::API::Origin::AFFILIATE_MEMBER => 'invite',
    Talkable::API::Origin::PURCHASE         => 'post-purchase',
    Talkable::API::Origin::EVENT            => nil,
  }

  class << self
    def register_affiliate_member(params)
      register_origin(Talkable::API::Origin::AFFILIATE_MEMBER, params)
    end

    def register_purchase(params)
      register_origin(Talkable::API::Origin::PURCHASE, params)
    end

    def register_event(params)
      register_origin(Talkable::API::Origin::EVENT, params)
    end

    private

    def register_origin(origin_type, params)
      origin_params = default_params(origin_type).merge(params)
      result = Talkable::API::Origin.create(origin_type, origin_params)
      origin = Talkable::Origin.parse(result)
      if offer = origin.offer
        # make sure that explicitly specified tags will be listed first
        tags = Array(origin_params[:campaign_tags]) | Array(offer.campaign_tags)
        offer.campaign_tags = tags.map(&:to_s).uniq
      end
      origin
    end

    def default_params(origin_type)
      {
        campaign_tags: DEFAULT_CAMPAIGN_TAGS[origin_type]
      }
    end
  end
end
