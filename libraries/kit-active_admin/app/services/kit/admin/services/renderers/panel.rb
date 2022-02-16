module Kit::Admin::Services::Renderers::Panel

  def self.render(ctx:, resource:, attrs:, title: nil, closed: nil, &block)
    closed ||= false

    if !title
      if resource
        _, title = resource.model_name.singular.split('models_')
        title = title.gsub('write_', '').gsub('read_', '').gsub('_', ' ').titleize.gsub(' ', '')
      else
        title = '?'
      end
    end

    panel_options = {}
    if closed == true
      panel_options['data-toggle'] = 'closed'
    end

    ctx.panel(title, panel_options) do
      if block
        ctx.div(class: 'panel_contents_inner_topbar') do
          yield ctx
        end
      end

      if resource
        ctx.attributes_table_for(resource) do
          Kit::Admin::Services::Renderers.build_for_html_display(ctx: ctx, type: :row, attrs: attrs)
        end
      end
    end

    [:ok]
  end

end
