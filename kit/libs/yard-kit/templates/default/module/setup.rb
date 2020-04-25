# frozen_string_literal: true
include ::Yard::Kit::Templates::Helpers::YardKitPluginHelper

def init
  sections :header, :box_info, T('docstring'), :children,
    :constant_summary, [T('docstring')], :inherited_constants,
    :attribute_summary, [:item_summary], :inherited_attributes,
    :method_summary, [:item_summary], :inherited_methods,
    :methodmissing, [T('method_details')],
    :attribute_details, [T('method_details')],
    :method_details_list, [T('method_details')]
end
