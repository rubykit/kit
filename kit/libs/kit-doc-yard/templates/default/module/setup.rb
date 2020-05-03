# frozen_string_literal: true
include ::Kit::Doc::Yard::TemplatePluginHelper

def init
  list = [
    :header,

    :section_moduledoc, [
      T('docstring'),
      :box_info,
    ],

    :section_summary, [

      :summary_modules, [
        :item_summary,
      ],

      :summary_classes, [
        :item_summary,
      ],

      :summary_subclasses, [
        :item_summary,
      ],

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
  ]

  sections(*list)
end
