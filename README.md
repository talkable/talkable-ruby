# Talkable Referral Marketing API Gem
[![](https://ci.solanolabs.com:443/Talkable/talkable-ruby/badges/branches/master?badge_token=c2445aee31992aafe3d8fda62fcde2708f6254f6)](https://ci.solanolabs.com:443/Talkable/talkable-ruby/suites/484176)

Referral marketing is one of the most powerful strategies for ecommerce sales growth. [Talkable]( https://www.talkable.com) provides a rich platform for referral marketing. You can integrate sophisticated referral marketing into your own ecommerce site using the Talkable Ruby gem for a Rails or Sinatra application.

## Demo

See an example application at http://github.com/talkable/talkable-spree-example.

See a live demo at http://spree-example.talkable.com.

## Tutorial

See a [detailed tutorial](https://railsapps.github.io/talkable-referral-marketing/) by [Learn Ruby on Rails](http://learn-rails.com/learn-ruby-on-rails.html) author Daniel Kehoe.

## Requirements

The gem requires:
 - Ruby version 2.3 or newer
 - Rack version 1.6.1 or newer

For integration with:
 - Ruby on Rails 5.0 or newer
 - Sinatra 1.4 or newer

## Gem Installation

Add to your project *Gemfile*:

```ruby
gem "talkable"
```

Then run:

```console
$ bundle install
```

## Using the Rails Generator

The Talkable gem provides a Ruby On Rails generator to automate the integration process.

```console
$ rails generate talkable:install
Your Talkable site slug: spree-example
Your Talkable API Key: SOME-API-KEY
Do you have a custom domain? [Y/n] n
```

The Talkable "site slug" is your Account Name (the name of your website, brand or company). You'll also need an API key which you'll find on the Account Settings page when you log in to your account. The generator will ask if you have a custom domain. If your website has a domain like example.com or www.example.com, you can answer, "no." If your website is at shop.example.com, you have a custom domain.

The generator adds and modifies several files:

```console
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

## Manual Integration

Here are the steps that are automated by the Ruby On Rails generator.

- [Initializer](#initializer)
- [Add Middleware](#add-middleware)
- [Referral Offer](#referral-offer)
- [Invite Page](#invite-page)

### Initializer

You'll need an initializer file to set the Talkable API configuration variables.

```ruby
### config/initializers/talkable.rb
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
For security, you should set these configuration variables from the Unix environment or use the Rails [encrypted credentials](https://www.engineyard.com/blog/rails-encrypted-credentials-on-rails-5.2) feature so the API key isn't stored in your GitHub repository.

### Add Middleware

Here's how you can add Talkable middleware manually.

_Note that if you're using Devise, it's important to load Talkable middleware before `Warden::Manager`, otherwise you can just go with `app.middleware.use Talkable::Middleware`._

```ruby
if defined? ::Warden::Manager
  app.middleware.insert_before Warden::Manager, Talkable::Middleware
else
  app.middleware.use Talkable::Middleware
end
```

### Referral Offer

Add code to retrieve a campaign and display a referral offer on every page of the application.

```ruby
### app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :load_talkable_offer

  protected

  def load_talkable_offer
    origin = Talkable.register_affiliate_member
    @offer ||= origin.offer if origin
  end

end
```

```erb
### app/views/shared/_talkable_offer.html.erb
<%- options ||= {} %>
<%- if offer %>
  <%== offer.advocate_share_iframe(options) %>
<% end -%>
```

### Invite Page

You can add an invite page by implementing an Invite Controller, with route and view files.

Add a route to the *config/routes.rb* file:

```ruby
 get '/invite' => 'invite#show'
```

```ruby
### app/controllers/invite_controller.rb
class InviteController < ApplicationController
  def show
    # Make sure you have configured Campaign Placements at Talkable site
    # or explicitly specify campaign tags
    # origin = Talkable.register_affiliate_member(campaign_tags: 'invite')
    origin = Talkable.register_affiliate_member
    @offer = origin.offer if origin
  end
end
```

```erb
### app/views/invite/show.html.erb
<div id="talkable-inline-offer-container"></div>
<%= render 'shared/talkable_offer',
  offer: @invite_offer,
  options: {iframe: {container: 'talkable-inline-offer-container'}} %>
```

## Customize Your Integration

### Getting Information About an Offer

```ruby
offer = origin.offer
offer.claim_links # => { facebook: "https://www.talkable.com/x/kqiYhR", sms: "https://www.talkable.com/x/PFxhNB" }
```

### Display an Offer Inside a View

Provide iframe options to show a share page in specific place.

```erb
<div id="talkable-inline-offer-container"></div>
<%== offer.advocate_share_iframe(iframe: {container: 'talkable-inline-offer-container'}) %>
```

## API Examples

See the [API docs](http://docs.talkable.com/api_v2.html) for full details.

- [Registering a purchase](#registering-a-purchase)
- [Registering other events](#registering-other-events)
- [More API examples](#more-api-examples)

### Registering a purchase

Here's how to register a purchase. We recommend you have submitted purchases for closing a referral loop.

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
      title: item.title,
    }
  end # optional
})
```

### Registering other events

Here's how to register other events.

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
      title: item.title,
    }
  end # optional
})
```

### More API examples

Here are more API examples.

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

## Questions? Need Help? Found a bug?

If you've got questions about integration, or need any other information, please feel free to [open an issue](https://github.com/talkable/talkable-ruby/issues) so we can reply. Found a bug? Go ahead and submit an [issue](https://github.com/talkable/talkable-ruby/issues).
