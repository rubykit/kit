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

      :summary_methods_class, [
        :item_summary,
      ],
      :summary_methods_class_inherited, [
        :item_summary,
      ],

      :summary_methods_instance, [
        :item_summary,
      ],
      :summary_methods_instance_inherited, [
        :item_summary,
      ],

      :summary_attributes_instance, [
        :item_summary,
      ],
      :summary_attributes_instance_inherited, [
        :item_summary,
      ],

      :summary_constants, [
        :item_summary,
      ],
      :summary_constants_inherited, [
        :item_summary,
      ],
    ],

    :section_methods_class, [
      :method_details, [
        T('docstring'),
      ],
    ],

    :section_methods_instance, [
      :method_details, [
        T('docstring'),
      ],
    ],

    :section_attributes_instance, [
      :method_details, [
        T('docstring'),
      ],
    ],

    :section_constants, [
      :constant_details, [
        T('docstring'),
      ],
    ],

    # This will probably never be used.
    #:methodmissing,       [T('method_details')],

  ]

  sections(*list)
end
