include YARD::Templates::Helpers::HtmlHelper

#require 'sassc'
require 'json'

def init
  super

  asset "assets/css/hexdoc_tmp.css", file("css/hexdoc_tmp.css", true)

  assets_list = [
    [File.join(File.expand_path('../../../..', __dir__), 'assets'), 'assets'],
  ]

  copy_assets(assets_list)

  #copy_static_assets
end

# @see yard/lib/yard/cli/yardoc.rb
def copy_assets(list)
  return unless options.serializer

  outpath = options.serializer.basepath
  list.each do |from, to|
    to    = File.join(outpath, to)
    from += '/.' if File.directory?(from)

    log.debug "Copying asset '#{ from }' to '#{ to }'"

    FileUtils.mkdir_p(to)
    FileUtils.cp_r(from, to)
  end
end

def stylesheets_full_list
  super # + %w[css/kit_yard.css css/kit_sass.scss]
end

# Generate YARD classic iframe full_list + JS versions used by this plugin.
def generate_list_contents
  # Regular HTML page for fallback
  asset(url_for_list(@list_type), erb(:full_list))

  # JS asset
  path_js_asset = "js/js_#{ @list_type }.js"
  template_id   = "full_list_#{ @list_type }_js".to_sym
  asset(path_js_asset, erb(template_id))
end

=begin
def generate_assets
  @object = Registry.root

  layout = Object.new.extend(T('layout'))

  files = (layout.javascripts + javascripts_full_list + layout.stylesheets + stylesheets_full_list).uniq

  files.each do |file_path|
    content = file(file_path, true)

    # Basic SCSS support
    if file_path.end_with?('.scss')
      #SassC.load_paths << File.dirname(__FILE__ + '/sass')
      content   = SassC::Engine.new(content).render
      #content   = SassC::Sass2Scss.convert(content)
      file_path = file_path.sub(/\.scss$/, '.css')
    end

    asset(file_path, content)
  end

  layout.menu_lists.each do |list|
    list_generator_method = "generate_#{ list[:type] }_list"
    if respond_to?(list_generator_method)
      send(list_generator_method)
    else
      log.error "Unable to generate '#{ list[:title] }' list because no method '#{ list_generator_method }' exists"
    end
  end

  generate_frameset
end
=end

def get_file_list(list:)
  list.map do |el|
    {
      # From YARD::Object::ExtraFileObject
      name:       el.name,
      type:       el.type,
      path:       el.path,

      href:       link_file(el),

      filename:   el.filename,

      attributes: el.attributes,
      locale:     el.locale,
    }
  end
end

def serialize_file_list(list:)
  JSON.pretty_generate(get_file_list(list: list))
end

def get_class_list(node: Registry.root, depth: 0)
  result = []

  children = run_verifier(node.children)
  if node == Registry.root
    children += @items.select { |o| o.namespace.is_a?(CodeObjects::Proxy) }
  end

  children = children.compact.sort_by(&:path)

  children.each do |child_node|
    next if !child_node.is_a?(CodeObjects::NamespaceObject)

    serialized_node = {
      # From YARD::Object::Base
      name:        child_node.name,
      type:        child_node.type,
      path:        child_node.path,
      href:        url_for(child_node),

      title:       child_node.title,

      files:       child_node.files,
      namespace:   {
        path: child_node.namespace.path,
      },
      source:      child_node.source,
      source_type: child_node.source_type,
      signature:   child_node.signature,

      docstring:   child_node.base_docstring.to_s,

      dynamic:     child_node.dynamic,
      group:       child_node.group,
      visibility:  child_node.visibility,
    }

    if child_node.class == YARD::CodeObjects::NamespaceObject
      serialized_node.merge!({
        groups:              child_node.groups,
        class_attributes:    child_node.class_attributes,
        instance_attributes: child_node.instance_attributes,
      })
    end

    if child_node.class == YARD::CodeObjects::ClassObject
      serialized_node.merge!({
        superclass:       child_node.superclass ? child_node.superclass.name : nil,
        inheritance_tree: child_node.inheritance_tree,
        is_exception:     child_node.is_exception?,
      })
    end

    if child_node.class == YARD::CodeObjects::ModuleObject
      serialized_node.merge!({
        inheritance_tree: child_node.inheritance_tree,
      })
    end

    if child_node.class != YARD::CodeObjects::ConstantObject
      serialized_node.merge!({
        children: get_class_list(node: child_node, depth: depth + 1),
      })
    end

    result << serialized_node
  end

=begin
    name = child.namespace.is_a?(CodeObjects::Proxy) ? child.path : child.name
    has_children = run_verifier(child.children).any? { |o| o.is_a?(CodeObjects::NamespaceObject) }
    out << "<li id='object_#{ child.path }' class='#{ tree.classes.join(' ') }'>"
    out << "<div class='item' style='padding-left:#{ tree.indent }'>"
    out << "<a class='toggle'></a> " if has_children
    out << linkify(child, name)
    out << " &lt; #{ child.superclass.name }" if child.is_a?(CodeObjects::ClassObject) && child.superclass
    out << "<small class='search_info'>"
    out << child.namespace.title
    out << '</small>'
    out << '</div>'
    tree.nest do
      out << "<ul>#{ class_list(child, tree) }</ul>" if has_children
    end
    out << '</li>'
  end
=end

  result
end

def serialize_class_list
  JSON.pretty_generate(get_class_list)
end

def get_method_list(list:)
  list.map do |el|
    {
      # From YARD::Object::Base

      name:               el.name,
      type:               el.type,
      path:               el.path,
      href:               url_for(el),

      title:              el.title,

      files:              el.files,
      namespace:          {
        path: el.namespace.path,
      },
      source:             el.source,
      source_type:        el.source_type,
      signature:          el.signature,

      docstring:          el.base_docstring.to_s,

      dynamic:            el.dynamic,
      group:              el.group,
      visibility:         el.visibility,

      # From YARD::CodeObjects::MethodObject

      aliases:            el.aliases,
      overriden_method:   el.overridden_method&.path,

      deprecated:         el.has_tag?(:deprecated),
      is_explicit:        el.is_explicit?,
      is_attribute:       el.is_attribute?,
      is_alias:           el.is_alias?,
      is_module_function: el.module_function?,
      is_reader:          el.reader?,
      is_writer:          el.writer?,
    }
  end
end

def serialize_method_list(list:)
  JSON.pretty_generate(get_method_list(list: list))
end
