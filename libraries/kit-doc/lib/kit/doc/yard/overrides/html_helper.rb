module YARD # rubocop:disable Style/Documentation
end

module YARD::Templates # rubocop:disable Style/Documentation
end

module YARD::Templates::Helpers # rubocop:disable Style/Documentation
end

module YARD::Templates::Helpers::HtmlHelper # rubocop:disable Style/Documentation

  # Overriden to remove syntax highlighting with `parse_codeblocks`.
  #
  # ### References
  # - https://github.com/lsegal/yard/blob/master/lib/yard/templates/helpers/html_helper.rb#L57
  #
  def htmlify(text, markup = options.markup)
    markup_meth = "html_markup_#{ markup }"
    return text unless respond_to?(markup_meth)
    return '' unless text
    return text unless markup

    html = send(markup_meth, text).dup
    if html.respond_to?(:encode)
      html = html.force_encoding(text.encoding) # for libs that mess with encoding
      html = html.encode(invalid: :replace, replace: '?')
    end

    resolve_links(html)
  end

  # Overidden to add `:with_toc_data` to `RedCarpet`.
  #
  # ### References
  # - https://github.com/lsegal/yard/blob/master/lib/yard/templates/helpers/html_helper.rb#L78
  #
  def html_markup_markdown(text)
    provider = markup_class(:markdown)
    case provider.to_s
    when 'RDiscount'
      provider.new(text, :autolink).to_html
    when 'RedcarpetCompat'
      provider.new(text, :no_intraemphasis, :gh_blockcode, :fenced_code, :autolink, :tables, :lax_spacing, :with_toc_data).to_html
    else
      provider.new(text).to_html
    end
  end

  # Overriden to remove relative links, as path are not nested with `Kit::Doc::Yard::FileSerializer`.
  #
  # References
  # - https://github.com/lsegal/yard/blob/master/lib/yard/templates/helpers/html_helper.rb#L365
  #
  def url_for(obj, anchor = nil, relative = true) # rubocop:disable Style/OptionalBooleanParameter
    link = nil
    return link unless serializer
    return link if obj.is_a?(::YARD::CodeObjects::Base) && run_verifier([obj]).empty?

    if obj.is_a?(::YARD::CodeObjects::Base) && !obj.is_a?(::YARD::CodeObjects::NamespaceObject)
      # If the obj is not a namespace obj make it the anchor.
      anchor = obj
      obj = obj.namespace
    end

    objpath = serializer.serialized_path(obj)
    return link unless objpath

    link = objpath

    link + (anchor ? '#' + urlencode(anchor_for(anchor)) : '') # rubocop:disable Style/StringConcatenation
  end

end
