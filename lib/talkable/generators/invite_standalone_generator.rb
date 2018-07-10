require 'talkable/generators/base_generator'

module Talkable
  class InviteStandaloneGenerator < BaseGenerator
    source_root File.expand_path("../templates", __FILE__)

    def add_invite_controller
      ext = template_lang

      copy_file "app/controllers/invite_controller.rb", "app/controllers/invite_controller.rb"
      copy_file "app/views/invite/show.html.#{ext}", "app/views/invite/show.html.#{ext}"
      route "get '/invite' => 'invite#show'"
    end
  end
end
