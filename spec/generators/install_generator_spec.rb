require 'spec_helper'

require 'rails/all'
require 'ammeter/init'

require 'talkable/generators/install_generator'

describe Talkable::InstallGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)

  let(:site_slug) { 'my-site-slug' }
  let(:api_key) { 'some-api-key' }
  let(:server) { 'http://examle.com' }

  let(:application_controller) { file('app/controllers/application_controller.rb') }
  let(:extension) { 'erb' }
  let(:layout) { file("app/views/layouts/application.html.#{extension}") }
  let(:partial) { file("app/views/shared/_talkable_offer.html.#{extension}") }

  let(:default_arguments) { [] }

  before do
    generator default_arguments # make sure generetor is created with passed arguments

    allow(generator.shell).to receive(:ask).and_return(
      site_slug,
      api_key,
      'Y',
      server
    )

    prepare_destination

    FileUtils.mkpath File.dirname(application_controller)
    FileUtils.mkpath File.dirname(layout)

    File.open(application_controller, "w") do |f|
      fixture = File.read(File.dirname(__FILE__) + '/../fixtures/files/application_controller.rb')
      f.write fixture
    end

    File.open(layout, "w") do |f|
      fixture = File.read(File.dirname(__FILE__) + "/../fixtures/files/#{File.basename(layout)}")
      f.write fixture
    end
  end

  describe '.add_initializer' do
    subject { file('config/initializers/talkable.rb') }
    before { run_generator }

    it do
      is_expected.to exist
      is_expected.to contain('config.site_slug  = "my-site-slug"')
      is_expected.to contain('config.api_key    = "some-api-key"')
      is_expected.to contain('config.server     = "http://examle.com"')
    end
  end

  describe '.inject_talkable_offer' do
    before { run_generator }

    it 'modifies application controller' do
      expect(application_controller).to have_correct_syntax
      expect(application_controller).to contain('before_action :load_talkable_offer')
      expect(application_controller).to have_method('load_talkable_offer')
    end

    shared_examples 'templatable' do
      it 'creates partial' do
        expect(partial).to exist
        expect(partial).to have_correct_syntax unless generator.options[:slim] # slim isn't suported yet
        expect(partial).to contain("= @offer.advocate_share_iframe")
      end

      it 'modifies application layout' do
        expect(layout).to have_correct_syntax unless generator.options[:slim] # slim isn't supported yet
        expect(layout).to contain("render 'shared/talkable_offer'")
      end
    end

    it_behaves_like 'templatable'

    context 'haml' do
      let(:default_arguments) { ['', '--haml'] }
      let(:extension) { 'haml' }

      before { run_generator }

      it_behaves_like 'templatable'
    end

    context 'slim' do
      let(:default_arguments) { ['', '--slim'] }
      let(:extension) { 'slim' }

      before { run_generator }

      it_behaves_like 'templatable'
    end

  end

end
