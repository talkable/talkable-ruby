class DummyCloseLoopController < ApplicationController
  def register
  end

  def submit
    Talkable.register_event(
        email: params[:email],
        event_number: SecureRandom.uuid,
        event_category: 'dummy_signup'
    )

    redirect_to dummy_close_loop_thank_you_path
  end

  def thank_you
  end
end
