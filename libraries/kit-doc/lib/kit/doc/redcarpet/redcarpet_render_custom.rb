require 'redcarpet'

# Custom RedCarpet renderer.
class Kit::Doc::RedcarpetRenderCustom < ::Redcarpet::Render::HTML

  # Characters to be removed from anchor links.
  ANCHOR_STRIPPED_CHARACTERS = ' -&+$,/:;=?@"{}#|^~[]`\\*()%.!\''

  # Generate a anchor from a given `text`.
  #
  # ### References
  # - https://github.com/vmg/redcarpet/blob/master/ext/redcarpet/html.c#L274
  def self.header_anchor(text)
    # Skip html tags
    text = Kit::Doc::Services::Utils.remove_html_tags(text)

    # Skip html entities
    text = Kit::Doc::Services::Utils.remove_html_entities(text)

    # Replace-non ASCII chars
    text = text.encode('ASCII', 'UTF-8', invalid: :replace, undef: :replace, replace: '-')

    # Replace invalid characters
    text = text.tr(ANCHOR_STRIPPED_CHARACTERS, '-')

    text.downcase
  end

  # Add `hover-link` behaviour to Headers.
  #
  # Bypasses `:with_toc_data` option so we need to reimplement it ourselves.
  #
  # ### References
  # - https://github.com/vmg/redcarpet/blob/master/ext/redcarpet/html.c#L322
  def header(text, level)
    anchor = self.class.header_anchor(text)

    %(
      <h#{ level } id="#{ anchor }" class="section-heading">
        <a href="##{ anchor }" class="hover-link"><span class="icon-link" aria-hidden="true"></span></a>
        #{ text }
      </h#{ level }>
    )
  end

  # Attempt to identify extras `.md` links that we can replace with the `.html` version.
  #
  # This feature is similar to YARD's `{file:file.md}` conceptually, but it support defaults markdown links.
  def link(link, title, content)
    # Note: maybe we want to remove the link entirely?
    link = '#' if !link

    if link.end_with?('.md')
      link_search = link.delete_prefix('/').gsub('../', '')
      if Kit::Doc::Services::Config.config[:files_extras].select { |path| path.end_with?(link_search) }
        link = File.basename(link).gsub('.md', '.html')
      end
    end

    %(<a href="#{ link }" title="#{ title }">#{ content }</a>)
  end

  # Attempt to identify & add link to objects references between back ticks.
  #
  # Note: is it not ideal to perform it here, as we have no context for relative references
  #  like `.class_method` or `#instance_method`. If we want to support this, the replacement
  #  needs to be done in the docstring with some regex to identify backtick.
  def codespan(code)
    link = Kit::Doc::Services::Utils.linkify(text: code)[1][:link]
    if link
      code = link
    end

    %(<code>#{ code }</code>)
  end

end
