require 'talkable/generators/base_generator'

module Talkable
  class ExampleNewsletterSignupGenerator < BaseGenerator
    source_root File.expand_path("../templates", __FILE__)

    def add_invite_controller
      ext = template_lang

      copy_file "app/controllers/example_newsletter_signup_controller.rb", "app/controllers/example_newsletter_signup_controller.rb"
      copy_file "app/views/example_newsletter_signup/register.html.#{ext}", "app/views/example_newsletter_signup/register.html.#{ext}"
      copy_file "app/views/example_newsletter_signup/thank_you.html.#{ext}", "app/views/example_newsletter_signup/thank_you.html.#{ext}"
      route "get '/example_newsletter_signup/thank_you' => 'example_newsletter_signup#thank_you'"
      route "get '/example_newsletter_signup' => 'example_newsletter_signup#register'"
      route "post '/example_newsletter_signup' => 'example_newsletter_signup#submit'"
    end
  end
end
