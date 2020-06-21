

sidebarNodes = {
  "extras":  [
  {
    "title": "API Reference",
    "id": "api_reference",
    "url": "api_reference.html",
    "group": ""
  },
  {
    "title": "Kit::Doc",
    "display_title": "Kit::Doc",
    "id": "README",
    "url": "README.html",
    "headers": [
      {
        "id": "Acknowledgements",
        "anchor": "acknowledgements"
      },
      {
        "id": "Features",
        "anchor": "features"
      },
      {
        "id": "Copyright and Licenses",
        "anchor": "copyright-and-licenses"
      }
    ],
    "group": "",
    "css_classes": [

    ]
  },
  {
    "title": "Getting started",
    "display_title": "Getting started",
    "id": "usage",
    "url": "usage.html",
    "headers": [
      {
        "id": "Adding the gem",
        "anchor": "adding-the-gem"
      },
      {
        "id": "Generating Kit::Doc config",
        "anchor": "generating-kit-doc-config"
      },
      {
        "id": "Edit your project info",
        "anchor": "edit-your-project-info"
      },
      {
        "id": "Generate documentation",
        "anchor": "generate-documentation"
      }
    ],
    "group": "",
    "css_classes": [

    ]
  },
  {
    "title": "Writing Documentation",
    "display_title": "Writing Documentation",
    "id": "writing_documentation",
    "url": "writing_documentation.html",
    "headers": [
      {
        "id": "Markdown",
        "anchor": "markdown"
      },
      {
        "id": "Documentation format",
        "anchor": "documentation-format"
      },
      {
        "id": "Documentation metadata",
        "anchor": "documentation-metadata"
      },
      {
        "id": "Recommendations",
        "anchor": "recommendations"
      },
      {
        "id": "Documentation != Code comments",
        "anchor": "documentation-code-comments"
      },
      {
        "id": "Hiding Internal Modules and Methods",
        "anchor": "hiding-internal-modules-and-methods"
      }
    ],
    "group": "",
    "css_classes": [

    ]
  }
],
  "modules": [
  {
    "title": "Kit::Doc::Services::Config",
    "display_title": "Config",
    "id": "Config",
    "url": "Kit.Doc.Services.Config.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "create_config-class_method",
            "properties": [

            ],
            "id": "#create_config"
          },
          {
            "anchor": "generate_source_url-class_method",
            "properties": [

            ],
            "id": "#generate_source_url"
          },
          {
            "anchor": "get_git_source_ref-class_method",
            "properties": [

            ],
            "id": "#get_git_source_ref"
          },
          {
            "anchor": "load_gemspec_data-class_method",
            "properties": [

            ],
            "id": "#load_gemspec_data"
          },
          {
            "anchor": "load_versions_file-class_method",
            "properties": [

            ],
            "id": "#load_versions_file"
          }
        ]
      },
      {
        "key": "attributes-instance",
        "name": "Instance attributes",
        "nodes": [
          {
            "anchor": "config-class_method",
            "properties": [

            ],
            "id": ".config"
          }
        ]
      },
      {
        "key": "constants",
        "name": "Constants",
        "nodes": [
          {
            "anchor": "SEMVER_REGEX-constant",
            "properties": [

            ],
            "id": "SEMVER_REGEX"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Doc::Services::Docstring",
    "display_title": "Docstring",
    "id": "Docstring",
    "url": "Kit.Doc.Services.Docstring.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "full-class_method",
            "properties": [

            ],
            "id": "#full"
          },
          {
            "anchor": "get_content_toc-class_method",
            "properties": [

            ],
            "id": "#get_content_toc"
          },
          {
            "anchor": "get_html_toc-class_method",
            "properties": [

            ],
            "id": "#get_html_toc"
          },
          {
            "anchor": "li_to_hash-class_method",
            "properties": [
              {
                "group": "tag",
                "name": "api",
                "value": "private"
              }
            ],
            "id": "#li_to_hash"
          },
          {
            "anchor": "summary-class_method",
            "properties": [

            ],
            "id": "#summary"
          },
          {
            "anchor": "toc-class_method",
            "properties": [

            ],
            "id": "#toc"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Doc::Services::Extras",
    "display_title": "Extras",
    "id": "Extras",
    "url": "Kit.Doc.Services.Extras.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "get_extras_list-class_method",
            "properties": [

            ],
            "id": "#get_extras_list"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Doc::Services::MarkdownPreprocessor",
    "display_title": "MarkdownPreprocessor",
    "id": "MarkdownPreprocessor",
    "url": "Kit.Doc.Services.MarkdownPreprocessor.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "preproc_conditionals-class_method",
            "properties": [

            ],
            "id": "#preproc_conditionals"
          },
          {
            "anchor": "preproc_variables-class_method",
            "properties": [

            ],
            "id": "#preproc_variables"
          }
        ]
      },
      {
        "key": "constants",
        "name": "Constants",
        "nodes": [
          {
            "anchor": "PREPROC_REGEX-constant",
            "properties": [

            ],
            "id": "PREPROC_REGEX"
          },
          {
            "anchor": "VARIABLES_REGEX-constant",
            "properties": [

            ],
            "id": "VARIABLES_REGEX"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Doc::Services::Methods",
    "display_title": "Methods",
    "id": "Methods",
    "url": "Kit.Doc.Services.Methods.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "get_alias_target-class_method",
            "properties": [

            ],
            "id": "#get_alias_target"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Doc::Services::Modules",
    "display_title": "Modules",
    "id": "Modules",
    "url": "Kit.Doc.Services.Modules.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "get_all_constants_as_list-class_method",
            "properties": [

            ],
            "id": "#get_all_constants_as_list"
          },
          {
            "anchor": "get_all_methods_as_list-class_method",
            "properties": [

            ],
            "id": "#get_all_methods_as_list"
          },
          {
            "anchor": "get_all_namespaces_as_hash-class_method",
            "properties": [

            ],
            "id": "#get_all_namespaces_as_hash"
          },
          {
            "anchor": "get_all_namespaces_as_list-class_method",
            "properties": [

            ],
            "id": "#get_all_namespaces_as_list"
          },
          {
            "anchor": "get_object_attributes-class_method",
            "properties": [

            ],
            "id": "#get_object_attributes"
          },
          {
            "anchor": "get_object_classes-class_method",
            "properties": [

            ],
            "id": "#get_object_classes"
          },
          {
            "anchor": "get_object_constants-class_method",
            "properties": [

            ],
            "id": "#get_object_constants"
          },
          {
            "anchor": "get_object_extended_into-class_method",
            "properties": [

            ],
            "id": "#get_object_extended_into"
          },
          {
            "anchor": "get_object_included_into-class_method",
            "properties": [

            ],
            "id": "#get_object_included_into"
          },
          {
            "anchor": "get_object_inherited_attributes-class_method",
            "properties": [

            ],
            "id": "#get_object_inherited_attributes"
          },
          {
            "anchor": "get_object_inherited_constants-class_method",
            "properties": [

            ],
            "id": "#get_object_inherited_constants"
          },
          {
            "anchor": "get_object_inherited_methods-class_method",
            "properties": [

            ],
            "id": "#get_object_inherited_methods"
          },
          {
            "anchor": "get_object_methods-class_method",
            "properties": [

            ],
            "id": "#get_object_methods"
          },
          {
            "anchor": "get_object_mixins_extend-class_method",
            "properties": [

            ],
            "id": "#get_object_mixins_extend"
          },
          {
            "anchor": "get_object_mixins_include-class_method",
            "properties": [

            ],
            "id": "#get_object_mixins_include"
          },
          {
            "anchor": "get_object_modules-class_method",
            "properties": [

            ],
            "id": "#get_object_modules"
          },
          {
            "anchor": "get_object_subclasses-class_method",
            "properties": [

            ],
            "id": "#get_object_subclasses"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Doc::Services::Properties",
    "display_title": "Properties",
    "id": "Properties",
    "url": "Kit.Doc.Services.Properties.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "has_private_apis?-class_method",
            "properties": [

            ],
            "id": "#has_private_apis?"
          },
          {
            "anchor": "object_html_data_properties-class_method",
            "properties": [

            ],
            "id": "#object_html_data_properties"
          },
          {
            "anchor": "object_properties-class_method",
            "properties": [

            ],
            "id": "#object_properties"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Doc::Services::Search",
    "display_title": "Search",
    "id": "Search",
    "url": "Kit.Doc.Services.Search.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "clean_content-class_method",
            "properties": [

            ],
            "id": "#clean_content"
          },
          {
            "anchor": "get_search_list-class_method",
            "properties": [
              {
                "group": "tag",
                "name": "todo",
                "value": "Add support for finding target method when in parents."
              }
            ],
            "id": "#get_search_list"
          },
          {
            "anchor": "handle_constants-class_method",
            "properties": [

            ],
            "id": "#handle_constants"
          },
          {
            "anchor": "handle_extras-class_method",
            "properties": [
              {
                "group": "tag",
                "name": "todo",
                "value": "handle h1/h2 like ExDoc"
              }
            ],
            "id": "#handle_extras"
          },
          {
            "anchor": "handle_methods-class_method",
            "properties": [

            ],
            "id": "#handle_methods"
          },
          {
            "anchor": "handle_modules-class_method",
            "properties": [

            ],
            "id": "#handle_modules"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Doc::Services::Sidebar",
    "display_title": "Sidebar",
    "id": "Sidebar",
    "url": "Kit.Doc.Services.Sidebar.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "find_element_groups-class_method",
            "properties": [

            ],
            "id": "#find_element_groups"
          },
          {
            "anchor": "get_ordered_groups_container-class_method",
            "properties": [

            ],
            "id": "#get_ordered_groups_container"
          },
          {
            "anchor": "transform_matchers-class_method",
            "properties": [

            ],
            "id": "#transform_matchers"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Doc::Services::Sidebar::Extras",
    "display_title": "Extras",
    "id": "Extras",
    "url": "Kit.Doc.Services.Sidebar.Extras.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "generate_headers-class_method",
            "properties": [

            ],
            "id": "#generate_headers"
          },
          {
            "anchor": "get_extras_list-class_method",
            "properties": [

            ],
            "id": "#get_extras_list"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": "sidebar-pl-1"
  },
  {
    "title": "Kit::Doc::Services::Sidebar::Modules",
    "display_title": "Modules",
    "id": "Modules",
    "url": "Kit.Doc.Services.Sidebar.Modules.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "generate_headers-class_method",
            "properties": [

            ],
            "id": "#generate_headers"
          },
          {
            "anchor": "generate_node_groups-class_method",
            "properties": [

            ],
            "id": "#generate_node_groups"
          },
          {
            "anchor": "get_all_namespaces_as_list-class_method",
            "properties": [

            ],
            "id": "#get_all_namespaces_as_list"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": "sidebar-pl-1"
  },
  {
    "title": "Kit::Doc::Services::Tasks",
    "display_title": "Tasks",
    "id": "Tasks",
    "url": "Kit.Doc.Services.Tasks.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "create_rake_task_documentation_all_versions!-class_method",
            "properties": [

            ],
            "id": "#create_rake_task_documentation_all_versions!"
          },
          {
            "anchor": "create_rake_task_documentation_all_versions_docs_config!-class_method",
            "properties": [

            ],
            "id": "#create_rake_task_documentation_all_versions_docs_config!"
          },
          {
            "anchor": "create_rake_task_documentation_all_versions_generate!-class_method",
            "properties": [

            ],
            "id": "#create_rake_task_documentation_all_versions_generate!"
          },
          {
            "anchor": "create_rake_task_documentation_all_versions_index!-class_method",
            "properties": [

            ],
            "id": "#create_rake_task_documentation_all_versions_index!"
          },
          {
            "anchor": "create_rake_task_documentation_generate!-class_method",
            "properties": [

            ],
            "id": "#create_rake_task_documentation_generate!"
          },
          {
            "anchor": "generate_docs_config-class_method",
            "properties": [

            ],
            "id": "#generate_docs_config"
          },
          {
            "anchor": "generate_documentation_all_versions-class_method",
            "properties": [

            ],
            "id": "#generate_documentation_all_versions"
          },
          {
            "anchor": "generate_html_redirect_file-class_method",
            "properties": [

            ],
            "id": "#generate_html_redirect_file"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Doc::Services::Tasks::Helpers",
    "display_title": "Helpers",
    "id": "Helpers",
    "url": "Kit.Doc.Services.Tasks.Helpers.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "display_css_padding-class_method",
            "properties": [

            ],
            "id": "#display_css_padding"
          },
          {
            "anchor": "display_last_name-class_method",
            "properties": [

            ],
            "id": "#display_last_name"
          },
          {
            "anchor": "resolve_files-class_method",
            "properties": [

            ],
            "id": "#resolve_files"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": "sidebar-pl-1"
  },
  {
    "title": "Kit::Doc::Services::Utils",
    "display_title": "Utils",
    "id": "Utils",
    "url": "Kit.Doc.Services.Utils.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "cleanup_files-class_method",
            "properties": [

            ],
            "id": "#cleanup_files"
          },
          {
            "anchor": "copy_assets-class_method",
            "properties": [

            ],
            "id": "#copy_assets"
          },
          {
            "anchor": "htmlify-class_method",
            "properties": [

            ],
            "id": "#htmlify"
          },
          {
            "anchor": "linkify-class_method",
            "properties": [

            ],
            "id": "#linkify"
          },
          {
            "anchor": "markup_for_file-class_method",
            "properties": [

            ],
            "id": "#markup_for_file"
          },
          {
            "anchor": "remove_html_entities-class_method",
            "properties": [

            ],
            "id": "#remove_html_entities"
          },
          {
            "anchor": "remove_html_tags-class_method",
            "properties": [

            ],
            "id": "#remove_html_tags"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Doc::Services::Utils::TemplateHelper",
    "display_title": "TemplateHelper",
    "id": "TemplateHelper",
    "url": "Kit.Doc.Services.Utils.TemplateHelper.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "html_markup_markdown-instance_method",
            "properties": [

            ],
            "id": ".html_markup_markdown"
          },
          {
            "anchor": "htmlify-instance_method",
            "properties": [

            ],
            "id": ".htmlify"
          },
          {
            "anchor": "initialize-instance_method",
            "properties": [
              {
                "group": "ruby",
                "name": "constructor",
                "value": true
              }
            ],
            "id": ".initialize"
          },
          {
            "anchor": "options-instance_method",
            "properties": [

            ],
            "id": ".options"
          },
          {
            "anchor": "to_html-instance_method",
            "properties": [

            ],
            "id": ".to_html"
          },
          {
            "anchor": "url_for-instance_method",
            "properties": [

            ],
            "id": ".url_for"
          }
        ]
      },
      {
        "key": "attributes-instance",
        "name": "Instance attributes",
        "nodes": [
          {
            "anchor": "current_yard_code_object-class_method",
            "properties": [

            ],
            "id": ".current_yard_code_object"
          },
          {
            "anchor": "file-instance_method",
            "properties": [
              {
                "group": "ruby",
                "name": "readonly",
                "value": true
              }
            ],
            "id": ".file"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": "sidebar-pl-1"
  },
  {
    "title": "Kit::Doc::RedcarpetRenderCustom",
    "display_title": "RedcarpetRenderCustom",
    "id": "RedcarpetRenderCustom",
    "url": "Kit.Doc.RedcarpetRenderCustom.html",
    "headers": [
      {
        "id": "References",
        "anchor": "references"
      }
    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "header_anchor-class_method",
            "properties": [

            ],
            "id": "#header_anchor"
          }
        ]
      },
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "codespan-instance_method",
            "properties": [

            ],
            "id": ".codespan"
          },
          {
            "anchor": "header-instance_method",
            "properties": [

            ],
            "id": ".header"
          },
          {
            "anchor": "link-instance_method",
            "properties": [

            ],
            "id": ".link"
          }
        ]
      },
      {
        "key": "constants",
        "name": "Constants",
        "nodes": [
          {
            "anchor": "ANCHOR_STRIPPED_CHARACTERS-constant",
            "properties": [

            ],
            "id": "ANCHOR_STRIPPED_CHARACTERS"
          }
        ]
      }
    ],
    "group": "Overrides",
    "css_classes": ""
  },
  {
    "title": "Kit::Doc::Yard",
    "display_title": "Yard",
    "id": "Yard",
    "url": "Kit.Doc.Yard.html",
    "headers": [

    ],
    "nodeGroups": [

    ],
    "group": "Overrides",
    "css_classes": ""
  },
  {
    "title": "Kit::Doc::Yard::FileSerializer",
    "display_title": "FileSerializer",
    "id": "FileSerializer",
    "url": "Kit.Doc.Yard.FileSerializer.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "serialized_path-instance_method",
            "properties": [

            ],
            "id": ".serialized_path"
          }
        ]
      }
    ],
    "group": "Overrides",
    "css_classes": "sidebar-pl-1"
  },
  {
    "title": "Kit::Doc::Yard::KitDocContractsHandler",
    "display_title": "KitDocContractsHandler",
    "id": "KitDocContractsHandler",
    "url": "Kit.Doc.Yard.KitDocContractsHandler.html",
    "headers": [
      {
        "id": "References",
        "anchor": "references"
      }
    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "process-instance_method",
            "properties": [

            ],
            "id": ".process"
          }
        ]
      }
    ],
    "group": "Overrides",
    "css_classes": "sidebar-pl-1"
  },
  {
    "title": "Kit::Doc::Yard::TemplatePluginHelper",
    "display_title": "TemplatePluginHelper",
    "id": "TemplatePluginHelper",
    "url": "Kit.Doc.Yard.TemplatePluginHelper.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "config-instance_method",
            "properties": [

            ],
            "id": ".config"
          }
        ]
      }
    ],
    "group": "Overrides",
    "css_classes": "sidebar-pl-1"
  },
  {
    "title": "RedcarpetCompat",
    "display_title": "RedcarpetCompat",
    "id": "RedcarpetCompat",
    "url": "RedcarpetCompat.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "initialize-instance_method",
            "properties": [
              {
                "group": "ruby",
                "name": "constructor",
                "value": true
              }
            ],
            "id": ".initialize"
          }
        ]
      },
      {
        "key": "attributes-instance",
        "name": "Instance attributes",
        "nodes": [
          {
            "anchor": "disabled-class_method",
            "properties": [

            ],
            "id": ".disabled"
          }
        ]
      }
    ],
    "group": "Overrides",
    "css_classes": ""
  },
  {
    "title": "YARD",
    "display_title": "YARD",
    "id": "YARD",
    "url": "YARD.html",
    "headers": [

    ],
    "nodeGroups": [

    ],
    "group": "Overrides",
    "css_classes": ""
  },
  {
    "title": "YARD::CLI::YardocOptions",
    "display_title": "YardocOptions",
    "id": "YardocOptions",
    "url": "YARD.CLI.YardocOptions.html",
    "headers": [

    ],
    "nodeGroups": [

    ],
    "group": "Overrides",
    "css_classes": "sidebar-pl-2"
  },
  {
    "title": "YARD::CodeObjects::Base",
    "display_title": "Base",
    "id": "Base",
    "url": "YARD.CodeObjects.Base.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "docstring_rendered-instance_method",
            "properties": [

            ],
            "id": ".docstring_rendered"
          }
        ]
      }
    ],
    "group": "Overrides",
    "css_classes": "sidebar-pl-2"
  },
  {
    "title": "YARD::CodeObjects::ExtraFileObject",
    "display_title": "ExtraFileObject",
    "id": "ExtraFileObject",
    "url": "YARD.CodeObjects.ExtraFileObject.html",
    "headers": [
      {
        "id": "Reference:",
        "anchor": "reference"
      }
    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "contents_rendered-instance_method",
            "properties": [

            ],
            "id": ".contents_rendered"
          },
          {
            "anchor": "contents_toc-instance_method",
            "properties": [

            ],
            "id": ".contents_toc"
          },
          {
            "anchor": "file-instance_method",
            "properties": [

            ],
            "id": ".file"
          },
          {
            "anchor": "initialize-instance_method",
            "properties": [
              {
                "group": "ruby",
                "name": "constructor",
                "value": true
              }
            ],
            "id": ".initialize"
          }
        ]
      }
    ],
    "group": "Overrides",
    "css_classes": "sidebar-pl-2"
  },
  {
    "title": "YARD::Logger",
    "display_title": "Logger",
    "id": "Logger",
    "url": "YARD.Logger.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "show_progress-instance_method",
            "properties": [

            ],
            "id": ".show_progress"
          }
        ]
      }
    ],
    "group": "Overrides",
    "css_classes": "sidebar-pl-1"
  },
  {
    "title": "YARD::Templates",
    "display_title": "Templates",
    "id": "Templates",
    "url": "YARD.Templates.html",
    "headers": [

    ],
    "nodeGroups": [

    ],
    "group": "Overrides",
    "css_classes": "sidebar-pl-1"
  },
  {
    "title": "YARD::Templates::Helpers",
    "display_title": "Helpers",
    "id": "Helpers",
    "url": "YARD.Templates.Helpers.html",
    "headers": [

    ],
    "nodeGroups": [

    ],
    "group": "Overrides",
    "css_classes": "sidebar-pl-2"
  },
  {
    "title": "YARD::Templates::Helpers::HtmlHelper",
    "display_title": "HtmlHelper",
    "id": "HtmlHelper",
    "url": "YARD.Templates.Helpers.HtmlHelper.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "html_markup_markdown-instance_method",
            "properties": [

            ],
            "id": ".html_markup_markdown"
          },
          {
            "anchor": "htmlify-instance_method",
            "properties": [

            ],
            "id": ".htmlify"
          },
          {
            "anchor": "url_for-instance_method",
            "properties": [

            ],
            "id": ".url_for"
          }
        ]
      }
    ],
    "group": "Overrides",
    "css_classes": "sidebar-pl-3"
  },
  {
    "title": "Kit::Doc::Railtie",
    "display_title": "Railtie",
    "id": "Railtie",
    "url": "Kit.Doc.Railtie.html",
    "headers": [

    ],
    "nodeGroups": [

    ],
    "group": "Various",
    "css_classes": ""
  }
],
  "tasks":   [],
};