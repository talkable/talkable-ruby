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

      offer = Talkable::Offer.parse(claim_links: claim_links_hash)
      expect(offer.claim_links.to_hash).to eq(Hashie.stringify_keys claim_links_hash)
    end
  end
end
