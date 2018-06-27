module Talkable
  class DummyCloseLoopGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    class_option :haml, type: :boolean, default: false
    class_option :slim, type: :boolean, default: false

    def add_invite_controller
      ext = template_lang

      copy_file "app/controllers/dummy_close_loop_controller.rb", "app/controllers/dummy_close_loop_controller.rb"
      copy_file "app/views/dummy_close_loop/register.html.#{ext}", "app/views/dummy_close_loop/register.html.#{ext}"
      copy_file "app/views/dummy_close_loop/thank_you.html.#{ext}", "app/views/dummy_close_loop/thank_you.html.#{ext}"
      route "get '/dummy_close_loop/thank_you' => 'dummy_close_loop#thank_you'"
      route "get '/dummy_close_loop' => 'dummy_close_loop#register'"
      route "post '/dummy_close_loop' => 'dummy_close_loop#submit'"
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
