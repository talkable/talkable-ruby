# Talkable Referral Programe API Gem

Talkable Ruby Gem to make your own referral program in Sinatra or Rails application



## Demo

Take a spree demo app and intall Talkable

## Intallation

``` ruby
gem "talkable"
```

## Using Generator

``` sh
rails generate talkable:install
Your talkable site slug (http://talkable.com): 
You API token (http://talkable.com/sites/zz/edit):
Do you want a different site to be used for non-production env? (y/n)
Your staging site slug:
Your staging site API token:


create config/initializers/talkable.rb
update app/controllers/application_controller.rb

create app/controllers/talkable_invite.rb
create app/views/talkable_invite/show.html.erb
update app/layouts/application.html.erb # floating widget install
update app/layouts/_talkable_floating_widget.html.erb
update config/routes.rb
```

## Configuration

``` ruby
Talkable.configure do |c|
  # required
  c.site_slug = 'hello'
  # or
  c.site_slug = Rails.env.production? ? "hello" : "hello-staging"
  # required
  c.api_token = Rails.env.production? ? "1235" : "6789" 
  # required
  c.server = 'http://invite.site.com' # fetched from site settings automatically using generator
  # optional
  c.js_integration_library = 'http://d2jj/integration/hello.js'  # default
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




## API

Full API support according to DOC


``` ruby
origin = Talkable::API.register_purchase(
    {
      email: 'a@b.com',
      subtotal: 100.53,
      coupon_codes: [],
      traffic_source: 'zz'
    },
    )
origin = Talkable::API.register_event()
origin = Talkable::API.register_affiliate_member(
offer = origin.offer
    {
      email: '...'
      sharing_channels: ['facebook', 'embedded_email', 'sms', 'other']
    }
    )

offer.claim_links # =>
                  # {
                  #   twitter: "http://invite.site.com/x/12356"
                  #   facebook: "http://invite.site.com/x/12356"
                  #   embedded_email: "http://invite.site.com/x/12356"
                  #   twitter: "http://invite.site.com/x/12356"
                  # }
```

## AD Offer Share page



User facing GEM API

``` erb
<%= offer.advocate_share_iframe %>

```

Generated code:


```  html
<div class='talkable-offer-xxx'>
  <!-- result of the JS evaluation - not ruby evaluation -->
  <iframe src="https://invite.site.com/x/38828?current_visitor_uuid=<uuid>"></iframe>
</div>

<script>
_talkableq.push(['init', {
  server: '...',
  site_id: '...',
  visitor_uuid: '...'
}])
_talkableq.push(['show_offer'], "https://invite.site.com/x/38828", {container: 'talkable-offer-xxx'})
</script>
```

## integration.js extension

`integration.js` additions. Suppose to be never used directly if using talkable gem

``` js
talkable.showOffer(offer.show_url)
```


## Self-Serve UI


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


``` ruby
# routes.rb
mount Talkable::Rack => 'talkable'
```


## TODO

Functionality:

* [ ] Gem infrustructure
* [ ] Configuration
* [ ] API
  * Custom Traffic Source
  * Custom User Agent
  * Visitors
  * Origins
  * Shares
  * Rewards
* [ ] Controller uuid hook
* [ ] Offer Share Iframe
  * [ ] Integration JS additions
  * [ ] Ruby iframe generation method
* [ ] Generator

Caveats:
* [ ] Prevent API call to create visitor on first request. Delay until user interacts with RAF.
