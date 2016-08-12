require 'spec_helper'

describe Talkable::Origin do
  let(:origin_hash) {{
    id: 31386398,
    order_number: 12,
    subtotal: 100.0,
    order_date: "2014-03-14T05:49:54.000-07:00",
    customer_id: nil,
    type: "Purchase",
    coupon_code: "",
  }}
  let(:offer_hash) {{
    short_url_code: "Jp8qY9",
    email: "affiliate@example.com",
    show_url: "https://www.talkable.com/x/5BN5h7",
    claim_url: "https://www.talkable.com/x/TM2OhR",
  }}

  describe ".parse" do
    it 'has origin data' do
      origin = Talkable::Origin.parse(origin: origin_hash)
      expect(origin.id).to eq(31386398)
      expect(origin.order_date).to be_kind_of(Time)
    end

    it 'ignores incorrect date' do
      expect {
        origin = Talkable::Origin.parse(origin: {order_date: 'invalid'})
      }.not_to raise_error
    end

    it 'has offer data' do
      origin = Talkable::Origin.parse(origin: origin_hash, offer: offer_hash)
      expect(origin.offer).to be_kind_of(Talkable::Offer)
      expect(origin.offer.show_url).to eq("https://www.talkable.com/x/5BN5h7")
    end

  end
end
