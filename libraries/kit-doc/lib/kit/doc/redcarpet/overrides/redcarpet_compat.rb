class ::RedcarpetCompat # rubocop:disable Style/Documentation

  class << self

    # Hack to allow generating documentation without `Kit::Doc`.
    attr_accessor :disabled

  end

  # Needed to use our custom Renderer because of the weird interface of RedcarpetCompat.
  #
  # ### References
  # - https://github.com/vmg/redcarpet/blob/master/lib/redcarpet/compat.rb#L5
  def initialize(text, *exts)
    @text = text

    exts_hash, render_hash = *parse_extensions_and_renderer_options(exts)

    if self.class.disabled == true
      renderer = Redcarpet::Render::HTML.new(render_hash)
    else
      renderer = Kit::Doc::RedcarpetRenderCustom.new(render_hash)
    end

    @markdown = Redcarpet::Markdown.new(renderer, exts_hash)
  end

end
