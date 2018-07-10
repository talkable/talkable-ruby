Talkable.configure do |config|
  # site slug is taken takes form ENV["TALKABLE_SITE_SLUG"]
  config.site_slug  = <%= @site_slug.inspect %>

  # api key is taken from ENV["TALKABLE_API_KEY"]
  config.api_key    = <%= @api_key.inspect %>
end
