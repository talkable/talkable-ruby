Talkable.configure do |config|
  # site slug takes form ENV["TALKABLE_SITE_SLUG"]
  config.site_slug  = <%= @site_slug.inspect %>

  # api key takes from ENV["TALKABLE_API_KEY"]
  config.api_key    = <%= @api_key.inspect %>
  <%- if defined?(@server) && @server.present? %>
  config.server     = <%= @server.inspect %>
  <%- else %>
  # custom server address - by default <%= Talkable::Configuration::DEFAULT_SERVER %>
  # config.server   =
  <%- end %>
end
