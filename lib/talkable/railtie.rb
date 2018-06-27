module Talkable
  class Railtie < Rails::Railtie
    generators do
      require 'talkable/generators/install_generator'
      require 'talkable/generators/invite_standalone_generator'
    end

    initializer "talkable.add_middleware" do |app|
      if defined? ::Warden::Manager
        app.middleware.insert_before Warden::Manager, Talkable::Middleware
      else
        app.middleware.use Talkable::Middleware
      end
    end
  end
end
