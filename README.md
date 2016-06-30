# talkable-ruby
Talkable Ruby Gem to make your own referral program


## Use Cases


``` ruby
Talkable::API.register_purchase()
offer = Talkable::API.register_origin()
campaign = offer.campaign


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

mount Talkable::Rack => 'talkable'
```



