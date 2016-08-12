module Talkable
  class Offer < Hashie::Mash
    def self.parse(result_hash)
      offer = self.new(result_hash[:offer])
      offer.claim_links ||= Hashie::Mash.new(result_hash[:claim_links])
      offer
    end
  end
end
