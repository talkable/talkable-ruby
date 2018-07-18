require 'spec_helper'

require 'rails/all'
require 'ammeter/init'

require 'talkable/generators/example_newsletter_signup_generator'

describe Talkable::ExampleNewsletterSignupGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)

  let(:extension) { 'erb' }
  let(:routes) { file("config/routes.rb") }

  let(:default_arguments) { [] }

  before do
    prepare_destination

    [routes].each do |rails_file|
      FileUtils.mkpath File.dirname(rails_file)

      File.open(rails_file, "w") do |f|
        fixture = File.read(File.dirname(__FILE__) + "/../fixtures/files/#{File.basename(rails_file)}")
        f.write fixture
      end
    end

    run_generator
  end

  describe '.add_invite_controller' do
    let(:example_newsletter_signup_controller) { file("app/controllers/example_newsletter_signup_controller.rb") }
    it 'creates invite controller' do
      expect(example_newsletter_signup_controller).to have_correct_syntax
      expect(example_newsletter_signup_controller).to have_method('register')
      expect(example_newsletter_signup_controller).to have_method('submit')
      expect(example_newsletter_signup_controller).to have_method('thank_you')
    end
  end

  describe '.add_invite_controller' do
    it 'adds route' do
      expect(routes).to have_correct_syntax
      expect(routes).to contain("get '/example_newsletter_signup/thank_you' => 'example_newsletter_signup#thank_you'")
      expect(routes).to contain("get '/example_newsletter_signup' => 'example_newsletter_signup#register'")
      expect(routes).to contain("post '/example_newsletter_signup' => 'example_newsletter_signup#submit'")
    end
  end
end
