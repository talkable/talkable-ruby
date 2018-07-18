class ExampleNewsletterSignupController < ApplicationController
  def register
  end

  def submit
    Talkable.register_event(
      email: params[:email],
      event_number: Digest::MD5.hexdigest(params[:email]),
      event_category: 'example_newsletter_signup'
    )

    redirect_to example_newsletter_signup_thank_you_path
  end

  def thank_you
  end
end
