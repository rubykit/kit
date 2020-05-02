class ::RedcarpetCompat

  # Needed to use our custom Renderer because of the weird interface of RedcarpetCompat.
  def initialize(text, *exts)
    exts_hash, render_hash = *parse_extensions_and_renderer_options(exts)
    @text     = text
    renderer  = Yard::Kit::RedcarpetRenderCustom.new(render_hash)
    @markdown = Redcarpet::Markdown.new(renderer, exts_hash)
  end

end
