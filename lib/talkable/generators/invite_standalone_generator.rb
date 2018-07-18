require 'talkable/generators/shared_generator_methods'

module Talkable
  class InviteStandaloneGenerator < Rails::Generators::Base
    include Talkable::SharedGeneratorMethods

    source_root File.expand_path("../templates", __FILE__)
    class_option :haml, type: :boolean, default: false
    class_option :slim, type: :boolean, default: false

    def add_invite_controller
      ext = template_lang

      copy_file "app/controllers/invite_controller.rb", "app/controllers/invite_controller.rb"
      copy_file "app/views/invite/show.html.#{ext}", "app/views/invite/show.html.#{ext}"
      route "get '/invite' => 'invite#show'"
    end
  end
end
