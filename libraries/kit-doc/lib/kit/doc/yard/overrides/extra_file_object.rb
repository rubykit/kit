# Overriden class from `YARD`.
#
# ### Reference:
# - https://github.com/lsegal/yard/blob/master/lib/yard/code_objects/extra_file_object.rb#L7
#
class ::YARD::CodeObjects::ExtraFileObject

  # ### Reference
  # - https://github.com/lsegal/yard/blob/master/lib/yard/code_objects/extra_file_object.rb#L18
  #
  def initialize(filename, contents = nil)
    self.filename   = filename
    self.name       = File.basename(filename).gsub(%r{\.[^.]+$}, '')
    self.attributes = SymbolHash.new(false)

    # Cache the original content.
    @original_contents = contents
    @parsed            = false
    @locale            = nil

    ensure_parsed

    # Reference: https://github.com/lsegal/yard/blob/master/templates/default/layout/html/setup.rb#L65
    self.attributes[:markup] ||= Kit::Doc::Services::Utils.markup_for_file(filename: self.filename)
  end

  # Cache the TOC version (usefull for the file title for instance).
  #
  # NOTE: this is an addition, not present in the original class.
  #
  def contents_toc
    @contents_toc ||= Kit::Doc::Services::Docstring.get_content_toc(content: self.contents)
  end

  # In the original code flow, the html rendering is done directly in templates.
  #
  # This allows us to access the rendered version anywhere, and to cache it.
  #
  # NOTE: this is an addition, not present in the original class.
  #
  def contents_rendered
    @contents_rendered ||= Kit::Doc::Services::Utils.htmlify(
      content:            self.contents,
      markdown_variables: Kit::Doc::Services::Config.config[:markdown_variables],
      markup:             self.attributes[:markup],
      yard_code_object:   self,
    )
  rescue Encoding::CompatibilityError => e
    puts "Kit::Doc - Error rendering `#{ filename }`."
    raise e
  end

  # Make this object interface compatible with Base CodeObjects.
  def file
    filename
  end

end
