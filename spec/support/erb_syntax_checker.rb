class ErbSyntaxChecker
  def initialize(erb_text)
    @erb_text = erb_text
  end

  def correct_syntax?
    render { "" }.result
    true
  rescue NameError
    true
  rescue SyntaxError
    false
  end

  private def render
    ERB.new(@erb_text).result(binding)
  end
end
