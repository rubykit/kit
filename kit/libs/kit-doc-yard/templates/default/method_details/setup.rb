# frozen_string_literal: true
include ::Kit::Doc::Yard::TemplatePluginHelper

def init
  sections :header, [
    :method_signature,
    :docstring_wrapper, [
      T('docstring'),
    ],
    #:source,
  ]
end
