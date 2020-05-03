module Kit::Doc::Services::Docstring

  def self.full(object:)
    docstring = (object.tags(:overload).size == 1 && obj.docstring.empty?) ? object.tag(:overload).docstring : object.docstring

    if docstring.summary.empty? && object.tags(:return).size == 1 && object.tag(:return).text
      docstring = ::YARD::Docstring.new(object.tag(:return).text.gsub(/\A([a-z])/, &:upcase).strip)
    end

    docstring
  end

  def self.summary(object:)
    full(object: object).summary
  end

end
