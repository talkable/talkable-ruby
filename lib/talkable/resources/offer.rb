module Talkable
  class Offer < Hashie::Mash
    def self.parse(result_hash)
      offer = self.new(result_hash[:offer])
      offer.claim_links ||= Hashie::Mash.new(result_hash[:claim_links])
      offer
    end

    def advocate_share_iframe(options = {})
      show_trigger = trigger_widget? && !options[:ignore_trigger]

      iframe_container = generate_container_id
      trigger_container = generate_container_id

      show_options = {
        url: show_url,
        iframe: default_iframe_options.merge(container: iframe_container),
        trigger_widget: {},
      }

      if show_trigger
        show_options.merge!({
          url: Furi.update(show_url, query: {only_trigger: 1}),
          trigger_widget: default_iframe_options.merge(container: trigger_container),
        })
      end

      render_share_snipet(show_options, iframe_container, trigger_container)
    end

    protected

    def generate_container_id
      "talkable-offer-#{SecureRandom.hex(3)}"
    end

    def default_iframe_options
      {width: '100%'}
    end

    def render_share_snipet(show_options, iframe_container, trigger_container)
      %Q{
<div id='#{iframe_container}'></div>
<div id='#{trigger_container}'></div>
<script>
_talkableq.push(['show_offer', #{show_options.to_json}])
</script>
      }
    end

  end
end
