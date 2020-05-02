class ::YARD::CodeObjects::ExtraFileObject

  def initialize(filename, contents = nil)
    self.filename = filename
    self.name = File.basename(filename).gsub(/\.[^.]+$/, '')
    self.attributes = SymbolHash.new(false)
    @original_contents = contents
    @parsed = false
    @locale = nil
    ensure_parsed

    # @ref https://github.com/lsegal/yard/blob/master/templates/default/layout/html/setup.rb#L65
    self.attributes[:markup] ||= Yard::Kit::Services::Utils.markup_for_file(filename: self.filename)
  end

  # Cache the TOC version (usefull for the file title)
  def contents_toc
    @contents_toc ||= Yard::Kit::Services::Extras.get_toc(file: self)
  end

  # In the original code flow, the html rendering is done directly in templates.
  # This allows us to access the rendered version anywhere, and to cache it.
  def contents_rendered
    @contents_rendered ||= Yard::Kit::Services::Utils.htmlify({
      content: self.contents,
      markup:  self.attributes[:markup],
    })
  end

end
