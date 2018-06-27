require 'spec_helper'

require 'rails/all'
require 'ammeter/init'

require 'talkable/generators/dummy_close_loop_generator'

describe Talkable::DummyCloseLoopGenerator, type: :generator do
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
    let(:dummy_loop_close_controller) { file("app/controllers/dummy_close_loop_controller.rb") }
    it 'creates invite controller' do
      expect(dummy_loop_close_controller).to have_correct_syntax
      expect(dummy_loop_close_controller).to have_method('register')
      expect(dummy_loop_close_controller).to have_method('submit')
      expect(dummy_loop_close_controller).to have_method('thank_you')
      # expect(dummy_loop_close_controller).to contain("skip_before_action :load_talkable_offer")
    end
  end

  describe '.add_invite_controller' do
    # let(:view) { file("app/views/invite/show.html.#{extension}") }
    #
    # it 'creates offer view' do
    #   expect(view).to have_correct_syntax unless generator.options[:slim] # slim isn't suported yet
    #   expect(view).to contain("render 'shared/talkable_offer'")
    # end

    it 'adds route' do
      expect(routes).to have_correct_syntax
      expect(routes).to contain("get '/dummy_close_loop/thank_you' => 'dummy_close_loop#thank_you'")
      expect(routes).to contain("get '/dummy_close_loop' => 'dummy_close_loop#register'")
      expect(routes).to contain("post '/dummy_close_loop' => 'dummy_close_loop#submit'")
    end
  end
end
