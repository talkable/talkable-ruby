Talkable.configure do |config|
  # site slug is taken from ENV["TALKABLE_SITE_SLUG"]
  config.site_slug  = <%= @site_slug.inspect %>

  # api key is taken from ENV["TALKABLE_API_KEY"]
  config.api_key    = <%= @api_key.inspect %>
  <%- if defined?(@server) && @server.present? %>
  config.server     = <%= @server.inspect %>
  <%- else %>
  # custom server address - by default <%= Talkable::Configuration::DEFAULT_SERVER %>
  # config.server   =
  <%- end %>
end
