module Kit::Admin::Services::Renderers::PanelList

  def self.render(ctx:, relation:, attrs:, title: nil, title_prefix: nil, closed: nil, paginated: nil, page_size: nil, order: nil, table_options: nil, &block)
    closed    ||= false
    paginated ||= true

    if relation.is_a?(Hash)
      relation_count = relation[:count]
      relation_data  = relation[:data]
    else
      relation_count = relation
      relation_data  = relation
    end

    count = relation_count&.count || 0

    if relation_data.is_a?(ActiveRecord::Relation)
      _, title = relation_data.model_name.singular.split('models_')
      title = title.gsub('write_', '').gsub('read_', '').gsub('_', ' ').titleize.gsub(' ', '')
    end
    title =   "#{ title_prefix } #{ title }" if title_prefix
    title =   "#{ title } - #{ count }"

    panel_options = {}
    if count == 0 || closed == true
      panel_options['data-toggle'] = 'closed'
    end

    ctx.panel title, panel_options do
      if block
        ctx.div(class: 'panel_contents_inner_topbar') do
          yield ctx
        end
      end

      if relation
        if paginated != false
          paginated_list(ctx: ctx, relation: relation_data, attrs: attrs, table_options: table_options, order: order, page_size: page_size)
        else
          list(ctx: ctx, relation: relation_data, attrs: attrs, table_options: table_options)
        end
      end
    end
  end

  def self.list(ctx:, relation:, attrs:, table_options: nil)
    table_options ||= {}

    table_options = table_options.reject { |k| k.to_s.start_with?('attrs_') }
    table_options[:class] = '' if !table_options[:class]
    table_options[:class] +=' table_list'

    ctx.table_for(relation, table_options) do |subcaller_ctx|
      Kit::Admin::Services::Renderers.build_for_html_display(ctx: subcaller_ctx, type: :column, attrs: attrs)
    end
  end

  def self.paginated_list(ctx:, relation:, attrs:, order: nil, page_size: nil, table_options: nil)
    page_size    ||= 50
    param_name     = "page_#{ relation.model_name.element }"

    paginated_relation = relation
      .order(order)
      .page(ctx.params[param_name])
      .per(page_size)

    ctx.paginated_collection(paginated_relation, download_links: false, param_name: param_name) do
      Kit::Admin::Services::Renderers::PanelList.list(ctx: ctx, relation: ctx.collection, attrs: attrs, table_options: table_options)
    end
  end

end
