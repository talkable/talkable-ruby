class InviteController < ApplicationController
  skip_before_action :load_talkable_offer # skip default trigger widget integration

  def show
    origin = Talkable.register_affiliate_member(campaign_tags: 'invite')
    @invite_offer = origin.offer if origin
  end
end
