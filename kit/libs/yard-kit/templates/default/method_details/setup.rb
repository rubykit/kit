# frozen_string_literal: true
include ::Yard::Kit::Templates::Helpers::YardKitPluginHelper

def init
  sections :header, [
    :method_signature,
    :docstring_wrapper, [
      T('docstring'),
    ],
    #:source,
  ]
end
