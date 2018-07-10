class Talkable::BaseGenerator < Rails::Generators::Base
  class_option :haml, type: :boolean, default: false
  class_option :slim, type: :boolean, default: false

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
