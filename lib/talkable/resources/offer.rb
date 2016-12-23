module Talkable
  class Offer < Hashie::Mash
    def self.parse(result_hash)
      return nil unless result_hash && result_hash[:offer]
      offer = self.new(result_hash[:offer])
      offer.claim_links ||= Hashie::Mash.new(result_hash[:claim_links])
      offer
    end

    def advocate_share_iframe(options = {})
      show_trigger = !options[:ignore_trigger]
      iframe_options = default_iframe_options.merge(options[:iframe] || {})
      url = show_trigger ? Furi.merge(show_url, query: {trigger_enabled: 1}) : show_url

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

    def default_iframe_options
      {
        container: "talkable-offer",
      }
    end

    def render_container_snipet(name)
      "<div id='#{CGI.escape(name)}'></div>"
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
