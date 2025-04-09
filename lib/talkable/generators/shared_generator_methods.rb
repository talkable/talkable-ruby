module Talkable::SharedGeneratorMethods
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
