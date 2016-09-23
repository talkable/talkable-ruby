# Talkable Referral Programe API Gem
[![](https://ci.solanolabs.com:443/Talkable/talkable-ruby/badges/branches/master?badge_token=c2445aee31992aafe3d8fda62fcde2708f6254f6)](https://ci.solanolabs.com:443/Talkable/talkable-ruby/suites/484176)

Talkable Ruby Gem to make your own referral program in Sinatra or Rails application

## Demo

Example of usage at http://github.com/talkable/talkable-spree-example

Live demo available at http://spree-example.talkable.com

## Requirements

Gem requires:
 - `Ruby` version since `1.9.3`
 - `Rack` version since `1.5.2`

Gem supports:
 - `Ruby on Rails` since `4.0.0`
 - `Sinatra` since `1.4.0`

## Intallation

``` ruby
gem "talkable"
```

### Step by step instruction

- [Setup configuration file __*__](#configuration)
- [Add Middleware __*__](#add-talkable-middleware)
- [Load an offer __*__](#load-an-offer)
- [Display a share page __*__](#display-an-offer-inside-view)
- [Integrate Conversion Points](#integrate-conversion-points)
 - [Registering a purchase](#registering-a-purchase)
 - [Registering other events](#registering-other-events)

__*__ - Automated in Ruby On Rails by using the generator

## Using the Ruby On Rails Generator

Talkable gem provides Ruby On Rails generator to automate an integration process.

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

### Add Talkable Middleware

``` ruby
  class Application < Rails::Application
    config.middleware.use Talkable::Middleware
  end
```

### Load an offer

Floating widget at every page

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

or invite page at specific path

```ruby
class InviteController < ApplicationController
  def show
    origin = Talkable.register_affiliate_member(campaign_tags: 'invite')
    @offer = origin.offer if origin
  end
end
```

### Getting information about an offer

```ruby
offer = origin.offer
offer.claim_links # => { facebook: "https://www.talkable.com/x/kqiYhR", sms: "https://www.talkable.com/x/PFxhNB" }
```

### Display an offer inside view

Provide iframe options to show a share page in specific place

```erb
<div id="talkable-inline-offer-container"></div>
<%== offer.advocate_share_iframe(iframe: {container: 'talkable-inline-offer-container'}) %>
```

## Integrate Conversion Points

### Registering a purchase

Registering a purchase has to be implemented manually based on your platform.
> It's highly required to have submitted purchases for closing a referral loop.

```ruby
Talkable::API::Origin.create(Talkable::API::Origin::PURCHASE, {
  email: 'customer@email.com',
  order_number: 'ORDER-12345',
  subtotal: 123.45,
  coupon_code: 'SALE10', # optional
  ip_address: request.remote_ip, # optional
  shipping_zip: '94103', # optional
  shipping_address: '290 Division St., Suite 405, San Francisco, California, 94103, United States', # optional
  items: order_items.map do |item|
    {
      price: item.price,
      quantity: item.quantity,
      product_id: item.product_id,
    }
  end # optional
})
```

### Registering other events

```ruby
Talkable::API::Origin.create(Talkable::API::Origin::EVENT, {
  email: 'customer@email.com',
  event_number: 'N12345',
  event_category: 'user_signuped',
  subtotal: 123.45, # optional
  coupon_code: 'SALE10', # optional
  ip_address: request.remote_ip, # optional
  shipping_zip: '94103', # optional
  shipping_address: '290 Division St., Suite 405, San Francisco, California, 94103, United States', # optional
  items: order_items.map do |item|
    {
      price: item.price,
      quantity: item.quantity,
      product_id: item.product_id,
    }
  end # optional
})
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
