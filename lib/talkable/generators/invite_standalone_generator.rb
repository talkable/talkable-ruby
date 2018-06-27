module Talkable
  class InviteStandaloneGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    class_option :haml, type: :boolean, default: false
    class_option :slim, type: :boolean, default: false

    def add_invite_controller
      ext = template_lang

      copy_file "app/controllers/invite_controller.rb", "app/controllers/invite_controller.rb"
      copy_file "app/views/invite/show.html.#{ext}", "app/views/invite/show.html.#{ext}"
      route "get '/invite' => 'invite#show'"
    end

    protected

    def template_lang
      @template_lang ||= if options[:haml]
        'haml'
      elsif options[:slim]
        'slim'
      else
        Rails::Generators.options[:rails][:template_engine].to_s.downcase
      end
    end

    def erb?
      template_lang == 'erb'
    end
  end
end
