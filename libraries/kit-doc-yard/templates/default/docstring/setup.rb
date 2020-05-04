# frozen_string_literal: true
include ::Kit::Doc::Yard::TemplatePluginHelper

def init
  return if object.docstring.blank? && !object.has_tag?(:api)
  sections :index, [:docstring_tags, [:private, :deprecated, :todo, :note], :docstring, [:text]], T('tags')
end