module Kit::Doc::Services::Docstring

  def self.full(object:)
    docstring = (object.tags(:overload).size == 1 && obj.docstring.empty?) ? object.tag(:overload).docstring : object.docstring

    if docstring.summary.empty? && object.tags(:return).size == 1 && object.tag(:return).text
      docstring = ::YARD::Docstring.new(object.tag(:return).text.gsub(/\A([a-z])/, &:upcase).strip)
    end

    docstring
  end

  def self.toc(object:)
    get_content_toc(content: full(object: object))
  end

  def self.summary(object:)
    full(object: object).summary
  end

  # Dirty hacks to get a Table of Content hash (based on mardown h1 / h2 / h3 / etc)
  # Only the two first levels are used by the template.
  def self.get_content_toc(content:)
    begin
      rendered  = get_html_toc(content: content)
      local_dom = ::Nokogiri::HTML.parse(rendered)
      result    = local_dom.css(':not(li) > ul > li').map { |node| li_to_hash(node: node) }
    rescue StandardError
      result = []
    end

    result
  end

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
  # @api private
  def self.li_to_hash(node:)
    {
      title:    (node > 'a')&.children&.first&.to_s || '',
      anchor:   (node > 'a')&.attribute('href')&.to_s&.gsub(/^#/, ''),
      sections: ((node > 'ul' > 'li')&.map { |subnode| li_to_hash(node: subnode) }) || [],
    }
  end

end
