# frozen_string_literal: true
include ::Yard::Kit::Templates::Helpers::YardKitPluginHelper

def init
  sections(:header, [
    T('method_details'),
  ])
end
