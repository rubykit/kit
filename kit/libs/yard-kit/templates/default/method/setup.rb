# frozen_string_literal: true
include ::Yard::Kit::YardKitPluginHelper

def init
  sections(:header, [
    T('method_details'),
  ])
end
