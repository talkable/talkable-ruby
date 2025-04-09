require 'spec_helper'

require 'rails/all'
require 'ammeter/init'

require 'talkable/generators/invite_standalone_generator'

describe Talkable::InviteStandaloneGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)

  let(:extension) { 'erb' }
  let(:routes) { file("config/routes.rb") }

  let(:default_arguments) { [] }

  before do
    prepare_destination

    [routes].each do |rails_file|
      FileUtils.mkpath File.dirname(rails_file)
      File.write(rails_file, File.read(File.dirname(__FILE__) + "/../fixtures/files/#{File.basename(rails_file)}"))
    end

    run_generator
  end

  describe '.add_invite_controller' do
    let(:invite_controller) { file("app/controllers/invite_controller.rb") }
    let(:view) { file("app/views/invite/show.html.#{extension}") }

    it 'creates invite controller' do
      expect(invite_controller).to have_correct_syntax
      expect(invite_controller).to have_method('show')
      expect(invite_controller).to contain("skip_before_action :load_talkable_offer")
    end

    it 'creates offer view' do
      expect(view).to have_correct_syntax unless generator.options[:slim] # slim isn't suported yet
      expect(view).to contain("render 'shared/talkable_offer'")
    end

    it 'adds route' do
      expect(routes).to have_correct_syntax
      expect(routes).to contain("get '/invite' => 'invite#show'")
    end
  end
end
