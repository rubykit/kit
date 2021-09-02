# Namespace for Docstring related operations.
module Kit::Doc::Services::Docstring

  # Get full "Docstring" for `object`.
  def self.full(object:)
    docstring = (object.tags(:overload).size == 1 && obj.docstring.empty?) ? object.tag(:overload).docstring : object.docstring

    if docstring.summary.empty? && object.tags(:return).size == 1 && object.tag(:return).text
      docstring = ::YARD::Docstring.new(object.tag(:return).text.gsub(%r{\A([a-z])}, &:upcase).strip)
    end

    docstring
  end

  # Get `Docstring` summary for `object`.
  def self.summary(object:)
    full(object: object).summary
  end

  # Get a hash table of content for a given object.
  def self.toc(object:)
    get_content_toc(content: full(object: object))
  end

  # Generate a "Table of Content" `hash` based on html headers (h1 / h2 / h3 / etc)
  #
  # Only the two first levels are used by the template.
  def self.get_content_toc(content:)
    begin
      content = Kit::Doc::Services::MarkdownPreprocessor.preproc_conditionals(
        content:   content,
        variables: Kit::Doc::Services::Config.config[:markdown_variables],
      )[1][:processed_content]

      rendered  = get_html_toc(content: content)
      local_dom = ::Nokogiri::HTML.parse(rendered)
      result    = local_dom.css(':not(li) > ul > li').map { |node| li_to_hash(node: node) }
    rescue StandardError
      result = []
    end

    result
  end

  # Generate an html "Table of Content".
  def self.get_html_toc(content:)
    begin
      renderer = ::Redcarpet::Render::HTML_TOC.new()
      markdown = ::Redcarpet::Markdown.new(renderer)
      # Redcarpet has a bug with # in code blocks, so we have to strip them with a regex (custom renderers don't help.)
      content  = content.gsub(%r{```.+?```}m, '')
      result   = markdown.render(content).delete("\n")
    rescue StandardError
      result = nil
    end

    result
  end

  # Flatten the DOM headers hierarchy recursively
  #
  # @api private
  def self.li_to_hash(node:)
    {
      title:    (node > 'a')&.children&.first&.to_s || '',
      anchor:   (node > 'a')&.attribute('href')&.to_s&.gsub(%r{^#}, ''),
      sections: ((node > 'ul' > 'li')&.map { |subnode| li_to_hash(node: subnode) }) || [], # rubocop:disable Lint/MultipleComparison
    }
  end

end
