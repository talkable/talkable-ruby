module Talkable
  DEFAULT_CAMPAIGN_TAGS = {
    Talkable::API::Origin::AFFILIATE_MEMBER => nil,
    Talkable::API::Origin::PURCHASE         => 'post-purchase'.freeze,
    Talkable::API::Origin::EVENT            => nil,
  }.freeze

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
      origin_params = default_params(origin_type).merge(params)
      result = Talkable::API::Origin.create(origin_type, origin_params)
      origin = Talkable::Origin.parse(result)
      origin
    end

    def default_params(origin_type)
      {
        r: Talkable.current_url,
        campaign_tags: DEFAULT_CAMPAIGN_TAGS[origin_type]
      }
    end
  end
end
