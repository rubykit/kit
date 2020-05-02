# frozen_string_literal: true
include ::Yard::Kit::YardKitPluginHelper

def init
  return if object.docstring.blank? && !object.has_tag?(:api)
  sections :index, [:private, :deprecated, :todo, :note, :text], T('tags')
end
