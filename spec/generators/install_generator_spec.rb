require 'spec_helper'

require 'rails/all'
require 'ammeter/init'

require 'talkable/generators/install_generator'
require './spec/support/erb_syntax_checker'

describe Talkable::InstallGenerator, type: :generator do
  destination File.expand_path("../../../tmp", __FILE__)

  let(:site_slug) { 'my-site-slug' }
  let(:api_key) { 'some-api-key' }
  let(:server) { 'http://example.com' }

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

    [application_controller, layout].each do |rails_file|
      FileUtils.mkpath File.dirname(rails_file)

      File.open(rails_file, "w") do |f|
        fixture = File.read(File.dirname(__FILE__) + "/../fixtures/files/#{File.basename(rails_file)}")
        f.write fixture
      end
    end

    run_generator
  end

  describe '.add_initializer' do
    subject { file('config/initializers/talkable.rb') }

    it do
      is_expected.to exist
      is_expected.to contain('config.site_slug  = "my-site-slug"')
      is_expected.to contain('config.api_key    = "some-api-key"')
      is_expected.to contain('config.server     = "http://example.com"')
    end
  end

  describe '.inject_talkable_offer' do
    it 'modifies application controller' do
      expect(application_controller).to have_correct_syntax
      expect(application_controller).to contain('before_action :load_talkable_offer')
      expect(application_controller).to have_method('load_talkable_offer')
    end
  end


  context 'when template language' do

    shared_examples 'templatable' do
      describe '.inject_talkable_offer' do
        it 'creates partial' do
          expect(partial).to exist
          expect(partial).to have_correct_syntax unless generator.options[:slim] # slim isn't suported yet
          expect(partial).to contain("= offer.advocate_share_iframe(options)")
        end

        it 'modifies application layout' do
          if generator.options[:slim]
            # slim isn't supported yet
          elsif extension == 'erb'
            # Cannot use `have_correct_syntax` matcher for ERB because of issue
            # https://github.com/alexrothenberg/ammeter/issues/66
            checker = ErbSyntaxChecker.new(File.read(layout))
            expect(checker).to be_correct_syntax
          else
            expect(layout).to have_correct_syntax
          end
          expect(layout).to contain("render 'shared/talkable_offer'")
        end
      end
    end

    context 'erb' do
      it_behaves_like 'templatable'
    end

    context 'haml' do
      let(:default_arguments) { ['', '--haml'] }
      let(:extension) { 'haml' }

      it_behaves_like 'templatable'
    end

    context 'slim' do
      let(:default_arguments) { ['', '--slim'] }
      let(:extension) { 'slim' }

      it_behaves_like 'templatable'
    end

  end

end
