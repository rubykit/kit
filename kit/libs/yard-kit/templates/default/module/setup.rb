# frozen_string_literal: true
include ::Yard::Kit::Templates::Helpers::YardKitPluginHelper

def init
  list = [
    :header,

    :section_moduledoc, [
      T('docstring'),
    ],

    :box_info,
    :children, # TODO: comment this out when the sidebar data is generated

    :section_summary, [

      :summary_class_methods, [
        :item_summary,
      ],
      :summary_class_inherited_methods, [
        :item_summary,
      ],

      :summary_instance_methods, [
        :item_summary,
      ],
      :summary_instance_inherited_methods, [
        :item_summary,
      ],

      # Attributes
      :attribute_summary, [
        :item_summary,
      ],
      :inherited_attributes,

      # Constants
      :constant_summary, [
        :constant_item_summary,
      ],
      :inherited_constants,
    ],

    :section_methods_class, [
      T('method_details'),
    ],

    :section_methods_instance, [
      T('method_details'),
    ],

    # This is unlikely to be used.
    :section_attributes, [
      :attribute_details,   [T('method_details')],
    ],

    #:section_attributes_class, [
    #  T('method_details'),
    #],

    #:section_attributes_instance, [
    #  T('method_details'),
    #],

    :section_constants, [
      :constant_details, [
        T('docstring'),
      ],
    ],

    # This will probably never be used.
    :methodmissing,       [T('method_details')],

  ]

  sections(*list)
end

def reject_api_hidden(list:)
  list.reject do |item|
    item.has_tag?(:api) && item.tag(:api).text == 'hide'
  end
end

def attr_listing
  list = super

  reject_api_hidden(list: list)
end

def constant_listing
  list = super

  reject_api_hidden(list: list)
end

def method_listing_class
  list = method_listing(false)
  list = reject_api_hidden(list: list)

  list
    .select { |m| m.scope == :class }
end

def method_listing_instance
  list = method_listing(false)
  list = reject_api_hidden(list: list)

  list
    .select { |m| m.scope == :instance }
end

def attr_listing_class
  list = attr_listing
  list = reject_api_hidden(list: list)

  list
    .select { |m| m.scope == :class }
end

def attr_listing_instance
  list = attr_listing
  list = reject_api_hidden(list: list)

  list
    .select { |m| m.scope == :instance }
end

def groups(list, type = "Method")
  groups_data = object.groups

  if groups_data
    list.each { |m| groups_data |= [m.group] if m.group && owner != m.namespace }
    others = list.select {|m| !m.group || !groups_data.include?(m.group) }
    groups_data.each do |name|
      items = list.select {|m| m.group == name }
      yield(items, name) unless items.empty?
    end
  else
    others     = []
    group_data = {}
    list.each do |itm|
      if itm.group
        (group_data[itm.group] ||= []) << itm
      else
        others << itm
      end
    end
    group_data.each { |group, items| yield(items, group) unless items.empty? }
  end

  return if others.empty?

  if others.first.respond_to?(:scope)
    scopes(others) { |items, scope| yield(items, "#{ scope.to_s.capitalize } #{ type.to_s.downcase }s") }
  else
    yield(others, "#{ type.to_s.capitalize }s")
  end
end
