require 'spec_helper'

describe Talkable::Offer do
  let(:offer_hash) {{
    short_url_code: "Jp8qY9",
    email: "affiliate@example.com",
    show_url: "https://www.talkable.com/x/5BN5h7",
    claim_url: "https://www.talkable.com/x/TM2OhR",
  }}
  let(:claim_links_hash) {{
    facebook: "https://www.talkable.com/x/8L6xO2",
    twitter: "https://www.talkable.com/x/KB89fO",
    custom: "https://www.talkable.com/x/Yf794w",
  }}

  describe ".parse" do
    it 'has offer data' do
      offer = Talkable::Offer.parse(offer: offer_hash)
      expect(offer.show_url).to eq("https://www.talkable.com/x/5BN5h7")
    end

    it 'has claim_links data' do
      offer = Talkable::Offer.parse(offer: offer_hash)
      expect(offer.claim_links).to be_kind_of(Hashie::Mash)

      offer = Talkable::Offer.parse(offer: offer_hash, claim_links: claim_links_hash)
      expect(offer.claim_links.to_hash).to eq(Hashie.stringify_keys claim_links_hash)
    end
  end

  describe ".advocate_share_iframe" do
    let(:offer) { Talkable::Offer.new(
      show_url: 'https://www.talkable.com/x/5BN5h7',
      campaign_tags: ['invite'],
    )}
    let(:options) { {} }
    let(:snippet) { offer.advocate_share_iframe(options) }

    it 'renders container' do
      expect(snippet).to include("<div id='talkable-offer'></div>")
    end

    it 'renders javascript' do
      expect(snippet).to include("_talkableq.push(['show_offer', {\"url\":\"https://www.talkable.com/x/5BN5h7?trigger_enabled=1")
    end

    context "with iframe oprions" do
      let(:options) { {
        iframe: {container: 'custom-container'}
      }}

      it "doesn't render container" do
        expect(snippet).not_to include("div")
        expect(snippet).to include('"iframe":{"container":"custom-container"')
      end
    end
  end
end
