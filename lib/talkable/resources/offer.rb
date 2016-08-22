module Talkable
  class Offer < Hashie::Mash
    def self.parse(result_hash)
      offer = self.new(result_hash[:offer])
      offer.claim_links ||= Hashie::Mash.new(result_hash[:claim_links])
      offer
    end

    def advocate_share_iframe(options = {})
      show_trigger = !options[:ignore_trigger]
      tag = campaign_tags.first
      iframe_options = default_iframe_options(tag).merge(options[:iframe] || {})
      url = show_trigger ? Furi.update(show_url, query: {trigger_enabled: 1}) : show_url

      snippets = []
      if !options[:iframe] || !options[:iframe][:container]
        snippets << render_container_snipet(iframe_options[:container])
      end
      snippets << render_share_snipet({
        url: url,
        iframe: iframe_options,
      })

      snippets.join("\n")
    end

    protected

    def default_iframe_options(tag = nil)
      tag ||= SecureRandom.hex(3)
      {
        container: "talkable-offer-#{tag}",
        width: '100%',
      }
    end

    def render_container_snipet(name)
      "<div id='#{name}'></div>"
    end

    def render_share_snipet(show_options)
      %Q{
<script>
_talkableq.push(['show_offer', #{show_options.to_json}])
</script>
      }
    end

  end
end
