# Talkable Referral Programe API Gem
[![](https://ci.solanolabs.com:443/Talkable/talkable-ruby/badges/branches/master?badge_token=c2445aee31992aafe3d8fda62fcde2708f6254f6)](https://ci.solanolabs.com:443/Talkable/talkable-ruby/suites/484176)

Talkable Ruby Gem to make your own referral program in Sinatra or Rails application

## Demo

Example of usage at http://github.com/talkable/talkable-spree-example

Live demo available at http://spree-example.talkable.com

## Intallation

``` ruby
gem "talkable"
```

## Using Generator

``` sh
rails generate talkable:install
```
``` sh
Your Talkable site slug: spree-example
Your Talkable API Key: SOME-API-KEY
Do you have a custom domain? [Y/n] n
```
``` sh
      create  config/initializers/talkable.rb
      insert  app/controllers/application_controller.rb
      insert  app/controllers/application_controller.rb
      create  app/views/shared
      create  app/views/shared/_talkable_offer.html.erb
      insert  app/views/layouts/application.html.erb
      create  app/controllers/invite_controller.rb
      create  app/views/invite/show.html.erb
       route  get '/invite' => 'invite#show'
```

## Configuration

``` ruby
Talkable.configure do |config|
  # site slug is taken form ENV["TALKABLE_SITE_SLUG"]
  config.site_slug  = "spree-example"

  # api key is taken from ENV["TALKABLE_API_KEY"]
  # config.api_key  =

  # custom server address - by default https://www.talkable.com
  # config.server   =

  # manually specified per-client integration library
  # config.js_integration_library =
end

```

## Manual Integration

- Add Talkable Middleware

``` ruby
  class Application < Rails::Application
    config.middleware.use Talkable::Middleware
  end
```

- Load an offer on every page

```ruby
class ApplicationController < ActionController::Base
  before_action :load_talkable_offer

  protected

  def load_talkable_offer
    origin = Talkable.register_affiliate_member(campaign_tags: 'popup')
    @offer ||= origin.offer if origin
  end

end
```

or for a specific action

```ruby
class InviteController < ApplicationController
  def show
    origin = Talkable.register_affiliate_member(campaign_tags: 'invite')
    @offer = origin.offer if origin
  end
end
```

- Display offer inside view

```erb
<div id="talkable-inline-offer-container"></div>
<%= render 'shared/talkable_offer', offer: @offer, options: {iframe: {container: 'talkable-inline-offer-container'}} %>
```

## Registering a purchase

Registering a purchase has to be implemented manually based on your platform.
> It's highly recommended to have submitted purchases for closing a referral loop.

```ruby
Talkable::API::Origin.create(Talkable::API::Origin::PURCHASE, {
  email: 'customer@email.com',
  order_number: 'ORDER-12345',
  subtotal: 123.45,
  coupon_code: 'SALE10',
  ip_address: request.remote_ip,
  shipping_zip: '94103',
  shipping_address: '290 Division St., Suite 405, San Francisco, California, 94103, United States',
  items: order_items.map do |item|
    {
      price: item.price,
      quantity: item.quantity,
      product_id: item.product_id,
    }
  end
})
```

## Integrate Conversion Points

Registering an affiliate origin

```ruby
origin = Talkable.register_affiliate_member(
  email: 'user@example.com',
  traffic_source: 'page_header',
  campaign_tags: 'invite',
)
```

Getting information about an offer

```ruby
offer = origin.offer
offer.claim_links # => { facebook: "https://www.talkable.com/x/kqiYhR", sms: "https://www.talkable.com/x/PFxhNB" }

```

Displaying a share page

``` erb
<%= offer.advocate_share_iframe %>

```

## API

Full API support according to [DOC](http://docs.talkable.com/api_v2.html)

```ruby
Talkable::API::Origin.create(Talkable::API::Origin::PURCHASE, {
  email: 'customer@domain.com',
  order_number: '123',
  subtotal: 34.56,
})
Talkable::API::Offer.find(short_url_code)
Talkable::API::Share.create(short_url_code, Talkable::API::Share::CHANNEL_SMS)
Talkable::API::Reward.find(visitor_uuid: '8fdf75ac-92b4-479d-9974-2f9c64eb2e09')
Talkable::API::Person.find(email)
Talkable::API::Person.update(email, unsubscribed: true)
Talkable::API::Referral.update(order_number, Talkable::API::Referral::APPROVED)
```

## TODO

Functionality:

* [x] Gem infrustructure
* [x] Configuration
* [x] API
  * Custom Traffic Source
  * Custom User Agent
  * Visitors
  * Origins
  * Shares
  * Rewards
* [x] Middleware
* [x] Offer Share Iframe
  * [x] Integration JS additions
  * [x] Ruby iframe generation method
* [x] Generator
* [ ] Documentation
  * Post-Checkout integration instructions
  * Events integration instructions
* [x] Setup demo with the most popular ruby shopping cart gem

Caveats:
* [ ] Prevent API call to create visitor on first request. Delay until user interacts with RAF.
