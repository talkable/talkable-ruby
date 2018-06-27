module Talkable
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    class_option :haml, type: :boolean, default: false
    class_option :slim, type: :boolean, default: false

    def ask_config_values
      @site_slug  = ask("Your Talkable site slug:")
      @api_key    = ask("Your Talkable API Key:")
      if yes?('Do you have a custom domain? [Y/n]')
        @server   = ask("Your custom domain [#{Talkable::Configuration::DEFAULT_SERVER}]:")
      end
    end

    def add_initializer
      template "config/initializers/talkable.rb", "config/initializers/talkable.rb"
    end

    def inject_talkable_offer
      inject_into_file "app/controllers/application_controller.rb", after: "class ApplicationController < ActionController::Base" do
<<-RUBY

  before_action :load_talkable_offer
RUBY
      end

      inject_into_file "app/controllers/application_controller.rb", before: /^end/ do
<<-RUBY
  protected

  def load_talkable_offer
    origin = Talkable.register_affiliate_member
    @offer ||= origin.offer if origin
  end
RUBY
      end

      empty_directory "app/views/shared/"

      if erb?
        copy_file "app/views/shared/_talkable_offer.html.erb", "app/views/shared/_talkable_offer.html.erb"
        inject_into_file "app/views/layouts/application.html.erb", before: "</body>" do
          "<%= render 'shared/talkable_offer', offer: @offer %>\n"
        end
      else
        ext = template_lang

        copy_file "app/views/shared/_talkable_offer.html.#{ext}", "app/views/shared/_talkable_offer.html.#{ext}"
        gsub_file "app/views/layouts/application.html.#{ext}", /^(\s*)\=\s*yield\s*$/ do |line|
          paddings = line.match(/(\s*)\=/)[1]
          "#{line}#{paddings}= render 'shared/talkable_offer', offer: @offer\n"
        end
      end
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
