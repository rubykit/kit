class ::RedcarpetCompat # rubocop:disable Style/Documentation

  # Needed to use our custom Renderer because of the weird interface of RedcarpetCompat.
  def initialize(text, *exts)
    @text = text

    exts_hash, render_hash = *parse_extensions_and_renderer_options(exts)

    renderer = Kit::Doc::RedcarpetRenderCustom.new(render_hash)
    @markdown = Redcarpet::Markdown.new(renderer, exts_hash)
  end

end
