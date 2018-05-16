module Talkable
  class Railtie < Rails::Railtie
    generators do
      require 'talkable/generators/install_generator'
    end

    initializer "talkable.add_middleware" do |app|
      app.middleware.insert_after Rack::TempfileReaper, Talkable::Middleware
    end
  end
end
