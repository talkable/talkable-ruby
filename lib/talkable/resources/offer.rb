module Talkable
  class Offer < JSONStruct
    def self.parse(result_hash)
      offer = self.new(result_hash[:offer])
      offer.claim_links ||= Talkable::JSONStruct.new(result_hash[:claim_links])
      offer
    end
  end
end
