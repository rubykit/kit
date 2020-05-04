# frozen_string_literal: true
include ::Kit::Doc::Yard::TemplatePluginHelper

def init
  sections(:header, [
    T('method_details'),
  ])
end
