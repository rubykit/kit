require 'nokogiri'

# Logic to generate `search_items.js` file
module Kit::Doc::Services::Search

  # @todo Add support for finding target method when in parents.
  def self.get_search_list(options:, url_generator:, anchor_generator:, verifier_runner:)
    args = { options: options, url_generator: url_generator, anchor_generator: anchor_generator, verifier_runner: verifier_runner }
    list = []

    list += handle_modules(**args)
    list += handle_methods(**args)
    list += handle_constants(**args)
    list += handle_extras(**args)

    list
  end

  # Generate search_items output for Extras
  # @todo handle h1/h2 like ExDoc
  def self.handle_extras(options:, url_generator:, **)
    list = Kit::Doc::Services::Extras.get_extras_list(options: options)

    list.map do |el|
      url     = url_generator.call(el)
      toc     = el.contents_toc
      content = clean_content(content: el.contents_rendered || el.contents)

      {
        type:  'extra',
        ref:   url,
        title: toc&.dig(0, :title) || el.name,
        doc:   content,
      }
    end
  end

  # Generate search_items output for Modules / Classes
  def self.handle_modules(options:, url_generator:, anchor_generator:, verifier_runner:)
    list = Kit::Doc::Services::Modules.get_all_namespaces_as_list(
      options:         options,
      verifier_runner: verifier_runner,
    )

    list.map do |el|
      anchor  = anchor_generator.call(el)
      url     = url_generator.call(el, anchor)
      content = clean_content(content: el.docstring_rendered)

      {
        type:  el.type,
        ref:   url,
        title: "#{ el.namespace.title }::#{ el.name }",
        doc:   content,
      }
    end
  end

  # Generate search_items output for Methods
  def self.handle_methods(options:, url_generator:, anchor_generator:, verifier_runner:)
    list = Kit::Doc::Services::Modules.get_all_methods_as_list(
      options:         options,
      verifier_runner: verifier_runner,
    )

    list.map do |el|
      anchor  = anchor_generator.call(el)
      url     = url_generator.call(el, anchor)
      content = clean_content(content: el.docstring_rendered)

      {
        type:  "#{ el.scope } method",
        ref:   url,
        title: "#{ el.namespace.title }#{ (el.scope == :class) ? '#' : '.' }#{ el.name }",
        doc:   content,
      }
    end
  end

  # Generate search_items output for Constants
  def self.handle_constants(options:, url_generator:, anchor_generator:, verifier_runner:)
    list = Kit::Doc::Services::Modules.get_all_constants_as_list(
      options:         options,
      verifier_runner: verifier_runner,
    )

    list.map do |el|
      anchor  = anchor_generator.call(el)
      url     = url_generator.call(el, anchor)
      content = clean_content(content: el.docstring_rendered)

      {
        type:  'constant',
        ref:   url,
        title: "#{ el.namespace.title }::#{ el.name }",
        doc:   content,
      }
    end
  end

  def self.clean_content(content:)
    content = Kit::Doc::Services::Utils.remove_html_tags(content)
      .gsub("\n", ' ')
      .gsub(%r{\s+}, ' ')

    # Generate text version
    Nokogiri::HTML.parse(content).text

  end

end
