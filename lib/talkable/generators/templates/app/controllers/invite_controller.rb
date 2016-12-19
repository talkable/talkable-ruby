class InviteController < ApplicationController
  skip_before_action :load_talkable_offer # skip default trigger widget integration

  def show
    # Make sure you have configured Campaign Placements at Talkable site
    # or explicitly specify campaign tags
    # origin = Talkable.register_affiliate_member(campaign_tags: 'invite')
    origin = Talkable.register_affiliate_member
    @invite_offer = origin.offer if origin
  end
end
