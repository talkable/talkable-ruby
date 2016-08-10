require 'time'

module Talkable
  class Origin < JSONStruct
    def self.parse(result_hash)
      origin_hash = result_hash[:origin]
      order_date = (origin_hash ? origin_hash[:order_date] : nil)

      if order_date
        origin_hash[:order_date] = begin
          Time.iso8601(order_date)
        rescue ArgumentError
          order_date
        end
      end

      origin = self.new(origin_hash)
      origin.offer ||= Talkable::Offer.parse(result_hash)
      origin
    end
  end
end
