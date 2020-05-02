# frozen_string_literal: true
include ::Yard::Kit::YardKitPluginHelper

def init
  sections :header, [
    :method_signature,
    :docstring_wrapper, [
      T('docstring'),
    ],
    #:source,
  ]
end
