module Talkable
  module API
    class Coupon < Base
      class << self
        def find(code)
          get "/coupons/#{code}"
        end

        def permission(code, email_or_username)
          get "/coupons/#{code}/permission/#{email_or_username}"
        end
      end
    end
  end
end
