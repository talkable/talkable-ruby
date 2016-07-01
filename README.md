# Talkable Referral Programe API Gem

Talkable Ruby Gem to make your own referral program in Sinatra or Rails application

## Use Cases

### Configuration

``` ruby
Talkable.configure do |c|
  # required
  c.site_slug = 'hello'
  c.api_token = '188773'
  # optional
  c.js_integration_library = 'http://d2jj/integration/hello.js'  # default
  c.server = 'http://invite.site.com' # fetched from site settings automatically by default
end
```

``` ruby
class ApplicationController < ActionController::Base

  initialize_talkable_api

end

# GEM internals
class Talkable
  module ActionControllerExtension
    def self.initialize_talkable_api
      before_action :talkable_before_request
    end

    def talkable_before_request
      cookies[:talkable_visitor_uuid] = params[:talkable_visitor_uuid] || talkable_visitor_uuid
      Talkable.with_uuid(talkable_visitor_uuid) do
        yield
      end
    end

    def talkable_visitor_uuid
      cookies[:talkable_visitor_uuid] ||= Talkable.find_or_generate_uuid
    end
  end
end
```


### Basics


``` ruby
offer = Talkable::API.register_purchase(
    {
      email: 'a@b.com',
      subtotal: 100.53,
      coupon_codes: [],
      traffic_source: 'zz'
    },
    )
offer = Talkable::API.register_event()
offer = Talkable::API.register_affiliate_member(
    {
      email: '...'
      sharing_channels: ['facebook', 'embedded_email', 'sms', 'other']
    }
    )
# {
#   twitter: "http://invite.site.com/x/12356"
#   facebook: "http://invite.site.com/x/12356"
#   embedded_email: "http://invite.site.com/x/12356"
#   twitter: "http://invite.site.com/x/12356"
# }
```

``` erb
<%= offer.advocate_share_iframe %>
```


### Self-Serve UI


``` ruby
offer.configure(
  facebook: {
    title: ['An offer for all my friends', 'Claim your reward'], # AB test
    description: 'Click this link and get #{campaign.friend_incentive.description} off on the merchant.com'
    image: "http://merchant.com/assets/fb_image.jpg"
  },
  twitter: {
    message: 'Click #{offer.claim_links.twitter} and get {{friend_incentive.description}} off on the merchant.com'
  },
)


offer.configure(
  twitter: {
    message: 'Click #{offer.claim_links.twitter} and get {{friend_incentive.description}} off on the merchant.com'
  },

)
```




``` js

offer = Talkable.offer(<%= offer.to_json %>)
$('.js-share-via-facebook').click(
    offer.shareViaFacebook()
)
$('.js-share-via-twitter').click(
    offer.shareViaTwitter()
)
$('.js-share-via-sms').click(
    offer.shareViaSms()
)
offer.bindClickLink($('.js-plain-offer-link'))
```


``` haml
%h1= offer.localize('offer_title')
%h1= offer.ab_test("Share with friends", "Get yourself a discount %{advocate_amount}", advocate_amount: campaign.advocate_incentive.description)
%p
  Share this offer with friends and get <%= campaign.advocate_incentive.description %>


%a.js-share-via-facebook Facebook
%a.js-share-via-twitter Twitter
%a.js-share-via-sms Twitter
```



``` sh
rails g talkable

app/views/talkable/share.html.erb
app/assets/javascripts/talkable.js
app/assets/stylesheets/talkable.css

# config/routes.rb
```

``` ruby
# routes.rb
mount Talkable::Rack => 'talkable'
```


