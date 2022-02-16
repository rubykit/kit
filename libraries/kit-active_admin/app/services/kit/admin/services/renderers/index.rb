module Kit::Admin::Services::Renderers::Index

  def self.render(ctx:, attrs:)
    Kit::Admin::Services::Renderers.build_for_html_display(ctx: ctx, type: :column, attrs: attrs)
  end

end
