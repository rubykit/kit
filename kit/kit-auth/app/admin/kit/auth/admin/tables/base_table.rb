
class Kit::Auth::Admin::Tables::BaseTable
#class Kit::Auth::KitAuthAdmin::Tables::BaseTable
  include Rails.application.routes.url_helpers

  attr_reader :ctx

  def initialize(ctx)
    @ctx = ctx
  end

  def attributes_for_list
    raise "IMPLEMENT ME"
  end

  def attributes_for_index
    raise "IMPLEMENT ME"
  end

  def attributes_for_show
    raise "IMPLEMENT ME"
  end

  def base_attributes
    {
      id:             :model_id,
      created_at:     nil,
      updated_at:     nil,
    }
  end


  def panel(el, options = {}, &block)
    options[:attrs_list] = :show if options[:attrs_list].blank?
    list = extract_attributes_list options

    title = options[:title]
    if !title
      if el
        title = el.model_name.singular.gsub('models_', '').gsub('_', ' ').titleize.gsub(' ', '')
      else
        title = self.class.to_s.gsub('Tables::', '')
      end
    end

    panel_options = {}
    if options[:panel_closed] == true
      panel_options['data-toggle'] = 'closed'
    end

    ctx.panel title, panel_options do
      if block
        ctx.div :class => 'panel_contents_inner_topbar' do
          yield ctx
        end
      end

      if el
        ctx.attributes_table_for el do
          build_for_html_display :row, list
        end
      end
    end
  end

  def panel_list(relation, options = {}, &block)
    if relation.is_a?(Hash)
      relation_count = relation[:count]
      relation_data  = relation[:data]
    else
      relation_count = relation
      relation_data  = relation
    end

    count = relation_count&.count || 0

    title = options[:title]
    if relation_data.is_a?(ActiveRecord::Relation)
      title ||= relation_data.model_name.plural.gsub('models_', '').gsub('_', ' ').titleize.gsub(' ', '')
    else
      title ||= self.class.to_s.gsub('Tables::', '')
    end
    title =   "#{options[:prefix]} #{title}" if options[:prefix]
    title =   "#{title} - #{count}"

    panel_options = {}
    if count == 0 || options[:panel_closed] == true
      panel_options['data-toggle'] = 'closed'
    end

    ctx.panel title, panel_options do
      if block
        ctx.div :class => 'panel_contents_inner_topbar' do
          yield ctx
        end
      end

      if relation
        if (count > 50 && options[:list] != :not_paginated) || options[:list] == :paginated
          paginated_list relation_data, options
        else
          list           relation_data, options
        end
      end
    end
  end

  def list(relation, options = {})
    list = extract_attributes_list options

    options = options.reject { |k| k.to_s.start_with?('attrs_') }
    options[:class] = '' if !options[:class]
    options[:class] +=' table_list'

    ctx.table_for(relation, options) do |subctx|
      @ctx = subctx
      build_for_html_display :column, list
    end
  end

  def paginated_list(relation, options = {})
    param_name     = "page_#{relation.model_name.element}"
    local_instance = self

    paginated_relation = relation
      .order(options[:order])
      .page(ctx.params[param_name])
      .per(50)

    ctx.paginated_collection(paginated_relation, download_links: false, param_name: param_name) do
      local_instance.list ctx.collection, options
    end
  end

  def errors_and_events_list(resource)
    errors_relation = Models::Error.where_target_eq(resource).order(created_at: :desc)
    events_relation = Models::Event.where_target_eq(resource).order(created_at: :desc)

    ctx.tabs do
      ctx.tab "Errors - #{errors_relation.count}" do
        Tables::Error.new(ctx).panel_list errors_relation
      end

      ctx.tab "Events - #{events_relation.count}" do
        Tables::Event.new(ctx).panel_list events_relation
      end
    end
  end

  def index(options = {})
    if !options[:attrs_list]
      options[:attrs_list] = :index
    end
    list = extract_attributes_list options

    build_for_html_display :column, list
  end

  def csv(options = {})
    list = extract_attributes_list options

    list.each do |name, body|
      case body
        when Symbol, NilClass
          body_nil_for_csv     :column, name
        when Array
          body_functor_for_csv :column, name, body[1]
        when Proc
          body_functor_for_csv :column, name, body
        else
          raise "Non handled `body` type"
      end
    end
  end

  def build_for_html_display(type, list)
    list.each do |name, body|
      case body
        when Symbol
          body_array type, name, [body]
        when Array
          body_array type, name, body
        when NilClass
          if name == :id
            body_array type, name, [:model_id]
          else
            send(type, name)
          end
        when Proc
          body_functor type, name, body
        else
          raise "Non handled `body`: #{body}"
      end
    end
  end

  def extract_attributes_list(params = {})
    list_name = "attributes_for_#{ params[:attrs_list] || :list }"

    unless self.respond_to? list_name
      raise "No such list #{list_name}"
    end

    attrs_params = params[:attrs_params]
    if attrs_params
      list = send(list_name, attrs_params).dup
    else
      list = send(list_name).dup
    end

    if params[:attrs_only]
      error_attrs = params[:attrs_only] - list.keys
      if error_attrs.size > 0
        raise "Invalid attributes: #{error_attrs}"
      end
      list.slice!(*params[:attrs_only])
    end
    if params[:attrs_except]
      error_attrs = params[:attrs_except] - list.keys
      if error_attrs.size > 0
        raise "Invalid attributes: #{error_attrs}"
      end
      list.except!(*params[:attrs_except])
    end

    list
  end

  protected

  def column(name)
    sortable = name

    if name == :starts_at
      sortable = :contest_starts_at
    end

    if block_given?
      ctx.column(name, sortable: sortable) do |el|
        yield el
      end
    else
      ctx.column(name, sortable: sortable)
    end
  end

  def row(name)
    if block_given?
      ctx.row(name) do |el|
        yield el
      end
    else
      ctx.row(name)
    end
  end

  def body_array(type, name, body)
    attr_type = body[0]
    functor   = body[1]

    if !functor
      if name == :id
        functor = ->(el) { el }
      else
        functor = ->(el) { el.send(name) }
      end
    end

    if attr_type == nil
      send(type, name) { |el| functor.call(el) }
      return
    end

    if attr_type.to_sym == :id
      attr_type = :model_id
    end

    method_name = "attr_type_#{attr_type}"
    if respond_to?(method_name, true)
      send(method_name, type, name, functor)
    else
      raise "Unknown attr_type `#{attr_type}` or method `#{method_name}`"
    end
  end

  def body_functor(type, name, functor)
    send(type, name) { |el| functor.call el }
  end

  def body_nil_for_csv(type, name)
    send(type, name) do |el|
      value = el.send(name)

      case value
        when ActiveRecord::Base
          value.id
        when Date, Time
          value.to_datetime.iso8601
        else
          value
      end
    end
  end

  def body_functor_for_csv(type, name, functor)
    send(type, name) do |el|
      value = functor.call el
      if value.is_a?(Array)
        value = value[0]
      end

      if value.is_a?(ApplicationRecord)
        value.id
      else
        value
      end
    end
  end

  def attr_type_model_id(type, name, functor)
    send(type, name) do |el|
      if name == :id
        ctx.code(ctx.auto_link el, "##{el.id}")
      else
        el = functor.call(el)

        text = "##{el.try(:id).try(:to_s)}"
        ctx.code(ctx.auto_link el, text)
      end
    end
  end

  def attr_type_model(type, name, functor)
    send(type, name) do |el|
      el = functor.call(el)
      text = el.try(:model_log_name)
      ctx.code(ctx.auto_link el, text)
    end
  end

  def attr_type_model_verbose(type, name, functor)
    send(type, name) do |el|
      el = functor.call(el)
      text = el.try(:model_verbose_name)
      ctx.code(ctx.auto_link el, text)
    end
  end

  def attr_type_model_color(type, name, functor)
    send(type, name) do |el|
      object = functor.call(el)

      if object
        str = "##{object.id} #{object.uid.upcase}"

        ctx.a href: ctx.auto_url_for(object) do
          ctx.status_tag(str, class: "#{object.model_name.element}_#{object.uid}")
        end
      else
        nil
      end
    end
  end

  def attr_type_status_tag(type, name, functor)
    send(type, name) do |el|
      v = functor.call(el)
      ctx.status_tag v[0], v[1]
    end
  end

  def attr_type_color_tag(type, name, functor)
    send(type, name) do |el|
      ctx.color_tag functor.call(el)
    end
  end

  def attr_type_percentage_bar(type, name, functor)
    send(type, name) do |el|
      ctx.div(:class => 'progress') do
        value = functor.call(el)
        ctx.div(:class => "progress-bar", :role => "progressbar", :style => "width: #{value.to_i}%;", :'aria-valuenow' => value.to_i, :'aria-valuemin' => "0", :'aria-valuemax' => "100") do
          '% 2.2f%' % value
        end
      end
    end
  end

  def attr_type_code(type, name, functor)
    send(type, name) do |el|
      ctx.code functor.call(el)
    end
  end

  def attr_type_color_tag_with_code(type, name, functor)
    send(type, name) do |el|
      color_tag, code = functor.call(el)
      ctx.span do
        ctx.color_tag color_tag
        ctx.code      code, style: 'margin-left: 5px;'
      end
    end
  end

  def attr_type_img(type, name, functor)
    send(type, name) do |el|
      ctx.img functor.call(el)
    end
  end

  def attr_type_pre(type, name, functor)
    send(type, name) do |el|
      ctx.pre functor.call(el)
    end
  end

  def attr_type_amount_tag(type, name, functor)
    send(type, name) do |el|
      ctx.amount_tag functor.call(el)
    end
  end

  def attr_type_link_to(type, name, functor)
    send(type, name) do |el|
      v = functor.call(el)
      ctx.send :link_to, *v
    end
  end

  def attr_type_code_link_to(type, name, functor)
    send(type, name) do |el|
      v = functor.call(el)
      ctx.code ctx.send :link_to, *v
    end
  end

  def attr_type_code_with_links(type, name, functor)
    send(type, name) do |el|
      v     = functor.call(el)
      links = v[1]

      ctx.code(v[0], style: 'margin-right: 4px;')

      links.each do |data|
        ctx.span(style: 'position: relative; top: -1px;') do
          if !data[2]
            data[2] = {}
          end

          if data[2].is_a?(Hash) && !data[2][:class]
            data[2][:class] = 'inline-btn'
          end

          ctx.link_to(*data)
        end
      end
      nil
    end
  end

  def attr_type_status_tag_with_links(type, name, functor)
    send(type, name) do |el|
      v     = functor.call(el)
      value = v[0]
      color = v[1]
      links = v[2]

      ctx.status_tag(value, color, style: 'margin-right: 4px;')

      links.each do |data|
        ctx.span(style: 'position: relative; top: -1px;') do
          if !data[2]
            data[2] = {}
          end

          if data[2].is_a?(Hash) && !data[2][:class]
            data[2][:class] = 'inline-btn'
          end

          ctx.link_to(*data)
        end
      end
      nil
    end
  end

  def attr_type_links(type, name, functor)
    send(type, name) do |el|
      links = functor.call(el) || []

      links.each do |data|
        ctx.span(style: 'position: relative; top: -1px;') do
          if !data[2]
            data[2] = {}
          end

          if data[2].is_a?(Hash) && !data[2][:class]
            data[2][:class] = 'inline-btn'
          end

          ctx.link_to(*data)
        end
      end
      nil
    end
  end

  def attr_type_auto_link(type, name, functor)
    send(type, name) do |el|
      v = functor.call(el)

      if v.is_a? Array
        object = v[0]
        text   = v[1] ? v[1] : object.try(:id)
      else
        object = v
        text   = object.try(:id)
      end
      ctx.auto_link object, text
    end
  end

  def attr_type_image_link_to(type, name, functor)
    send(type, name) do |el|
      v = functor.call(el)
      if v[1] && v[2]
        ctx.link_to(ctx.image_tag(v[1], v[3]), v[2])
      else
        ctx.code "MISSING IMAGE"
      end
    end
  end

  def attr_type_pre_yaml(type, name, functor)
    send(type, name) do |el|
      v = functor.call(el)
      ctx.pre v.to_yaml.gsub("---\n", '').gsub("--- ", '')
    end
  end

  def attr_type_jsonb_targets(type, name, functor)
    send(type, name) do |el|
      v = functor.call(el)

      list = []

      v.each do |k, id|
        model_name  = k.gsub('_id', '').camelize
        if model_name == 'ErrorWrite'
          model_name = 'Error'
        end
        model_klass = "Models::#{model_name}".constantize
        config = ctx.active_admin_resource_for model_klass

        url = url_for config.route_instance_path id
        text = "#{model_name}##{id}"
        list << ctx.link_to(text, url)
      end

      ctx.code ctx.raw list.join(' ')
    end
  end

end