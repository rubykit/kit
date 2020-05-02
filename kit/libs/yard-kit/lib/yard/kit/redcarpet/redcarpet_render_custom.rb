require 'redcarpet'

class Yard::Kit::RedcarpetRenderCustom < ::Redcarpet::Render::HTML

  STRIPPED = " -&+$,/:;=?@\"#{}|^~[]`\\*()%.!'"

  # @ref https://github.com/vmg/redcarpet/blob/master/ext/redcarpet/html.c#L274
  def self.header_anchor(text)
    # Skip html tags
    text = Yard::Kit::Services::Utils.remove_html_tags(text)

    # Skip html entities
    text = Yard::Kit::Services::Utils.remove_html_entities(text)

    # Replace-non ASCII chars
    text = text.encode("ASCII", "UTF-8", invalid: :replace, undef: :replace, replace: '-')

    # Replace invalid characters
    text = text.tr(STRIPPED, '-')

    text.downcase
  end

  # Add hover-link behaviour to Headers
  # @note Bypass `:with_toc_data` option so we need to reimplement it ourselves.
  # @ref https://github.com/vmg/redcarpet/blob/master/ext/redcarpet/html.c#L322
  def header(text, level)
    anchor = self.class.header_anchor(text)
    %{
      <h#{level} id="#{anchor}" class="section-heading">
        <a href="##{anchor}" class="hover-link"><span class="icon-link" aria-hidden="true"></span></a>
        #{text}
      </h#{level}>
    }
  end

end

