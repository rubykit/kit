

sidebarNodes = {
  "extras":  [
  {
    "title": "API Reference",
    "id": "api_reference",
    "url": "api_reference.html",
    "group": ""
  },
  {
    "title": "Kit::Contract",
    "display_title": "Kit::Contract",
    "id": "README",
    "url": "README.html",
    "headers": [
      {
        "id": "Features",
        "anchor": "features"
      },
      {
        "id": "References",
        "anchor": "references"
      },
      {
        "id": "Copyright &amp; License",
        "anchor": "copyright"
      }
    ],
    "group": "",
    "css_classes": [

    ]
  },
  {
    "title": "Usage",
    "display_title": "Usage",
    "id": "usage",
    "url": "usage.html",
    "headers": [

    ],
    "group": "",
    "css_classes": [

    ]
  },
  {
    "title": "Why Contracts?",
    "display_title": "Why Contracts?",
    "id": "why_contracts",
    "url": "why_contracts.html",
    "headers": [

    ],
    "group": "",
    "css_classes": [

    ]
  }
],
  "modules": [
  {
    "title": "Kit::Contract",
    "display_title": "Kit::Contract",
    "id": "Contract",
    "url": "Kit.Contract.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "constants",
        "name": "Constants",
        "nodes": [
          {
            "anchor": "VERSION-constant",
            "properties": [

            ],
            "id": "VERSION"
          }
        ]
      }
    ],
    "group": "",
    "css_classes": [

    ]
  },
  {
    "title": "Kit::Contract::BuiltInContracts",
    "display_title": "Kit::Contract::BuiltInContracts",
    "id": "BuiltInContracts",
    "url": "Kit.Contract.BuiltInContracts.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "constants",
        "name": "Constants",
        "nodes": [
          {
            "anchor": "BigDecimal-constant",
            "properties": [

            ],
            "id": "BigDecimal"
          },
          {
            "anchor": "Boolean-constant",
            "properties": [

            ],
            "id": "Boolean"
          },
          {
            "anchor": "Callable-constant",
            "properties": [

            ],
            "id": "Callable"
          },
          {
            "anchor": "Callables-constant",
            "properties": [

            ],
            "id": "Callables"
          },
          {
            "anchor": "Complex-constant",
            "properties": [

            ],
            "id": "Complex"
          },
          {
            "anchor": "FalseClass-constant",
            "properties": [

            ],
            "id": "FalseClass"
          },
          {
            "anchor": "Float-constant",
            "properties": [

            ],
            "id": "Float"
          },
          {
            "anchor": "Int-constant",
            "properties": [

            ],
            "id": "Int"
          },
          {
            "anchor": "Integer-constant",
            "properties": [

            ],
            "id": "Integer"
          },
          {
            "anchor": "NegInt-constant",
            "properties": [

            ],
            "id": "NegInt"
          },
          {
            "anchor": "NegativeInteger-constant",
            "properties": [

            ],
            "id": "NegativeInteger"
          },
          {
            "anchor": "Nil-constant",
            "properties": [

            ],
            "id": "Nil"
          },
          {
            "anchor": "NonNil-constant",
            "properties": [

            ],
            "id": "NonNil"
          },
          {
            "anchor": "Numeric-constant",
            "properties": [

            ],
            "id": "Numeric"
          },
          {
            "anchor": "PosInt-constant",
            "properties": [

            ],
            "id": "PosInt"
          },
          {
            "anchor": "PositiveInteger-constant",
            "properties": [

            ],
            "id": "PositiveInteger"
          },
          {
            "anchor": "Rational-constant",
            "properties": [

            ],
            "id": "Rational"
          },
          {
            "anchor": "String-constant",
            "properties": [

            ],
            "id": "String"
          },
          {
            "anchor": "Symbol-constant",
            "properties": [

            ],
            "id": "Symbol"
          },
          {
            "anchor": "TrueClass-constant",
            "properties": [

            ],
            "id": "TrueClass"
          }
        ]
      }
    ],
    "group": "",
    "css_classes": [

    ]
  },
  {
    "title": "Kit::Contract::Error",
    "display_title": "Kit::Contract::Error",
    "id": "Error",
    "url": "Kit.Contract.Error.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "backtrace-instance_method",
            "properties": [
              {
                "group": "tag",
                "name": "api",
                "value": "private"
              }
            ],
            "id": ".backtrace"
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
            "anchor": "message-instance_method",
            "properties": [
              {
                "group": "tag",
                "name": "api",
                "value": "private"
              }
            ],
            "id": ".message"
          }
        ]
      }
    ],
    "group": "",
    "css_classes": [

    ]
  },
  {
    "title": "Kit::Contract::Mixin",
    "display_title": "Kit::Contract::Mixin",
    "id": "Mixin",
    "url": "Kit.Contract.Mixin.html",
    "headers": [

    ],
    "nodeGroups": [

    ],
    "group": "",
    "css_classes": [

    ]
  },
  {
    "title": "Kit::Contract::Services::MethodWrapper",
    "display_title": "MethodWrapper",
    "id": "MethodWrapper",
    "url": "Kit.Contract.Services.MethodWrapper.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "create_alias-class_method",
            "properties": [

            ],
            "id": "#create_alias"
          },
          {
            "anchor": "create_method_wrapper-class_method",
            "properties": [
              {
                "group": "tag",
                "name": "note",
                "value": "We are forced to avoid splat as it makes it impossible to perform any introspection on the parameters of the method. This leads to this akward parameter forwarding."
              }
            ],
            "id": "#create_method_wrapper"
          },
          {
            "anchor": "wrap-class_method",
            "properties": [

            ],
            "id": "#wrap"
          }
        ]
      },
      {
        "key": "constants",
        "name": "Constants",
        "nodes": [
          {
            "anchor": "METHOD_PREFIX-constant",
            "properties": [

            ],
            "id": "METHOD_PREFIX"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::Services::RubyHelpers",
    "display_title": "RubyHelpers",
    "id": "RubyHelpers",
    "url": "Kit.Contract.Services.RubyHelpers.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "generate_args_in-class_method",
            "properties": [
              {
                "group": "tag",
                "name": "note",
                "value": "a valid order looks like: `[:req, :opt], :rest, [:req, :opt], [:key, :keyreq], :keyrest, :block`"
              }
            ],
            "id": "#generate_args_in"
          },
          {
            "anchor": "get_parameters-class_method",
            "properties": [

            ],
            "id": "#get_parameters"
          },
          {
            "anchor": "handle_key_args-class_method",
            "properties": [

            ],
            "id": "#handle_key_args"
          },
          {
            "anchor": "parameters_as_array_to_s-class_method",
            "properties": [
              {
                "group": "tag",
                "name": "note",
                "value": "This is a poor man Ruby equivalent of javascript `arguments`"
              }
            ],
            "id": "#parameters_as_array_to_s"
          },
          {
            "anchor": "parameters_as_signature_to_s-class_method",
            "properties": [
              {
                "group": "tag",
                "name": "note",
                "value": "Default values are not available, so they are lost. Kudos to Ruby."
              }
            ],
            "id": "#parameters_as_signature_to_s"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::Services::Runtime",
    "display_title": "Runtime",
    "id": "Runtime",
    "url": "Kit.Contract.Services.Runtime.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "active?-class_method",
            "properties": [

            ],
            "id": "#active?"
          },
          {
            "anchor": "instrument-class_method",
            "properties": [

            ],
            "id": "#instrument"
          },
          {
            "anchor": "run_contracts!-class_method",
            "properties": [
              {
                "group": "tag",
                "name": "raise",
                "value": ""
              }
            ],
            "id": "#run_contracts!"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::Services::Store",
    "display_title": "Store",
    "id": "Store",
    "url": "Kit.Contract.Services.Store.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "add_and_generate_key-class_method",
            "properties": [

            ],
            "id": "#add_and_generate_key"
          },
          {
            "anchor": "get-class_method",
            "properties": [

            ],
            "id": "#get"
          },
          {
            "anchor": "get_next_key-class_method",
            "properties": [

            ],
            "id": "#get_next_key"
          },
          {
            "anchor": "local_store-class_method",
            "properties": [

            ],
            "id": "#local_store"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::Services::Validation",
    "display_title": "Validation",
    "id": "Validation",
    "url": "Kit.Contract.Services.Validation.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "all-class_method",
            "properties": [

            ],
            "id": "#all"
          },
          {
            "anchor": "valid?-class_method",
            "properties": [

            ],
            "id": "#valid?"
          }
        ]
      }
    ],
    "group": "Services",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::And",
    "display_title": "And",
    "id": "And",
    "url": "Kit.Contract.BuiltInContracts.And.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "call-instance_method",
            "properties": [

            ],
            "id": ".call"
          },
          {
            "anchor": "setup-instance_method",
            "properties": [

            ],
            "id": ".setup"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::Any",
    "display_title": "Any",
    "id": "Any",
    "url": "Kit.Contract.BuiltInContracts.Any.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "call-class_method",
            "properties": [

            ],
            "id": "#call"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::Args",
    "display_title": "Args",
    "id": "Args",
    "url": "Kit.Contract.BuiltInContracts.Args.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "call-instance_method",
            "properties": [

            ],
            "id": ".call"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::Array",
    "display_title": "Array",
    "id": "Array",
    "url": "Kit.Contract.BuiltInContracts.Array.html",
    "headers": [
      {
        "id": "Supported contract types:",
        "anchor": "supported-contract-types"
      },
      {
        "id": "Supported internal types of behaviour:",
        "anchor": "supported-internal-types-of-behaviour"
      },
      {
        "id": "Todo: add exemples.",
        "anchor": "todo-add-exemples"
      }
    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "at-class_method",
            "properties": [

            ],
            "id": "#at"
          },
          {
            "anchor": "call-class_method",
            "properties": [

            ],
            "id": "#call"
          },
          {
            "anchor": "every-class_method",
            "properties": [

            ],
            "id": "#every"
          },
          {
            "anchor": "instance-class_method",
            "properties": [

            ],
            "id": "#instance"
          },
          {
            "anchor": "meta-class_method",
            "properties": [

            ],
            "id": "#meta"
          },
          {
            "anchor": "of-class_method",
            "properties": [

            ],
            "id": "#of"
          },
          {
            "anchor": "size-class_method",
            "properties": [

            ],
            "id": "#size"
          },
          {
            "anchor": "with-class_method",
            "properties": [

            ],
            "id": "#with"
          }
        ]
      },
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "add_contract-instance_method",
            "properties": [

            ],
            "id": ".add_contract"
          },
          {
            "anchor": "at-instance_method",
            "properties": [

            ],
            "id": ".at"
          },
          {
            "anchor": "call-instance_method",
            "properties": [

            ],
            "id": ".call"
          },
          {
            "anchor": "every-instance_method",
            "properties": [

            ],
            "id": ".every"
          },
          {
            "anchor": "instance-instance_method",
            "properties": [

            ],
            "id": ".instance"
          },
          {
            "anchor": "of-instance_method",
            "properties": [

            ],
            "id": ".of"
          },
          {
            "anchor": "setup-instance_method",
            "properties": [

            ],
            "id": ".setup"
          },
          {
            "anchor": "size-instance_method",
            "properties": [

            ],
            "id": ".size"
          },
          {
            "anchor": "to_contracts-instance_method",
            "properties": [

            ],
            "id": ".to_contracts"
          },
          {
            "anchor": "with-instance_method",
            "properties": [

            ],
            "id": ".with"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::ArrayHelper",
    "display_title": "ArrayHelper",
    "id": "ArrayHelper",
    "url": "Kit.Contract.BuiltInContracts.ArrayHelper.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "get_every_value_contract-class_method",
            "properties": [

            ],
            "id": "#get_every_value_contract"
          },
          {
            "anchor": "get_index_contract-class_method",
            "properties": [

            ],
            "id": "#get_index_contract"
          },
          {
            "anchor": "get_instance_contract-class_method",
            "properties": [

            ],
            "id": "#get_instance_contract"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::Delayed",
    "display_title": "Delayed",
    "id": "Delayed",
    "url": "Kit.Contract.BuiltInContracts.Delayed.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "call-instance_method",
            "properties": [

            ],
            "id": ".call"
          },
          {
            "anchor": "setup-instance_method",
            "properties": [

            ],
            "id": ".setup"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::Eq",
    "display_title": "Eq",
    "id": "Eq",
    "url": "Kit.Contract.BuiltInContracts.Eq.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "call-instance_method",
            "properties": [

            ],
            "id": ".call"
          },
          {
            "anchor": "setup-instance_method",
            "properties": [

            ],
            "id": ".setup"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::Hash",
    "display_title": "Hash",
    "id": "Hash",
    "url": "Kit.Contract.BuiltInContracts.Hash.html",
    "headers": [
      {
        "id": "Supported contract types:",
        "anchor": "supported-contract-types"
      },
      {
        "id": "Supported internal types of behaviour:",
        "anchor": "supported-internal-types-of-behaviour"
      },
      {
        "id": "Todo: add exemples.",
        "anchor": "todo-add-exemples"
      }
    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "call-class_method",
            "properties": [

            ],
            "id": "#call"
          },
          {
            "anchor": "every-class_method",
            "properties": [

            ],
            "id": "#every"
          },
          {
            "anchor": "every_key-class_method",
            "properties": [

            ],
            "id": "#every_key"
          },
          {
            "anchor": "every_value-class_method",
            "properties": [

            ],
            "id": "#every_value"
          },
          {
            "anchor": "instance-class_method",
            "properties": [

            ],
            "id": "#instance"
          },
          {
            "anchor": "meta-class_method",
            "properties": [

            ],
            "id": "#meta"
          },
          {
            "anchor": "of-class_method",
            "properties": [

            ],
            "id": "#of"
          },
          {
            "anchor": "size-class_method",
            "properties": [

            ],
            "id": "#size"
          },
          {
            "anchor": "with-class_method",
            "properties": [

            ],
            "id": "#with"
          }
        ]
      },
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "add_contract-instance_method",
            "properties": [

            ],
            "id": ".add_contract"
          },
          {
            "anchor": "call-instance_method",
            "properties": [

            ],
            "id": ".call"
          },
          {
            "anchor": "every-instance_method",
            "properties": [

            ],
            "id": ".every"
          },
          {
            "anchor": "every_key-instance_method",
            "properties": [

            ],
            "id": ".every_key"
          },
          {
            "anchor": "every_value-instance_method",
            "properties": [

            ],
            "id": ".every_value"
          },
          {
            "anchor": "instance-instance_method",
            "properties": [

            ],
            "id": ".instance"
          },
          {
            "anchor": "of-instance_method",
            "properties": [

            ],
            "id": ".of"
          },
          {
            "anchor": "setup-instance_method",
            "properties": [

            ],
            "id": ".setup"
          },
          {
            "anchor": "size-instance_method",
            "properties": [

            ],
            "id": ".size"
          },
          {
            "anchor": "to_contracts-instance_method",
            "properties": [

            ],
            "id": ".to_contracts"
          },
          {
            "anchor": "with-instance_method",
            "properties": [

            ],
            "id": ".with"
          },
          {
            "anchor": "without-instance_method",
            "properties": [

            ],
            "id": ".without"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::HashHelper",
    "display_title": "HashHelper",
    "id": "HashHelper",
    "url": "Kit.Contract.BuiltInContracts.HashHelper.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "get_every_key_contract-class_method",
            "properties": [

            ],
            "id": "#get_every_key_contract"
          },
          {
            "anchor": "get_every_key_value_contract-class_method",
            "properties": [

            ],
            "id": "#get_every_key_value_contract"
          },
          {
            "anchor": "get_every_value_contract-class_method",
            "properties": [

            ],
            "id": "#get_every_value_contract"
          },
          {
            "anchor": "get_instance_contract-class_method",
            "properties": [

            ],
            "id": "#get_instance_contract"
          },
          {
            "anchor": "get_keyword_arg_contract-class_method",
            "properties": [

            ],
            "id": "#get_keyword_arg_contract"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::In",
    "display_title": "In",
    "id": "In",
    "url": "Kit.Contract.BuiltInContracts.In.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "beautified_values-instance_method",
            "properties": [

            ],
            "id": ".beautified_values"
          },
          {
            "anchor": "call-instance_method",
            "properties": [

            ],
            "id": ".call"
          },
          {
            "anchor": "setup-instance_method",
            "properties": [

            ],
            "id": ".setup"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::InstantiableContract",
    "display_title": "InstantiableContract",
    "id": "InstantiableContract",
    "url": "Kit.Contract.BuiltInContracts.InstantiableContract.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-class",
        "name": "Class methods",
        "nodes": [
          {
            "anchor": "[]-class_method",
            "properties": [

            ],
            "id": "#[]"
          },
          {
            "anchor": "named-class_method",
            "properties": [

            ],
            "id": "#named"
          }
        ]
      },
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "call-instance_method",
            "properties": [

            ],
            "id": ".call"
          },
          {
            "anchor": "debug-instance_method",
            "properties": [

            ],
            "id": ".debug"
          },
          {
            "anchor": "get_meta-instance_method",
            "properties": [

            ],
            "id": ".get_meta"
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
            "anchor": "meta-instance_method",
            "properties": [

            ],
            "id": ".meta"
          },
          {
            "anchor": "named-instance_method",
            "properties": [

            ],
            "id": ".named"
          },
          {
            "anchor": "safe_nested_call-instance_method",
            "properties": [

            ],
            "id": ".safe_nested_call"
          },
          {
            "anchor": "setup-instance_method",
            "properties": [

            ],
            "id": ".setup"
          }
        ]
      },
      {
        "key": "attributes-instance",
        "name": "Instance attributes",
        "nodes": [
          {
            "anchor": "disable_safe_nesting-class_method",
            "properties": [

            ],
            "id": ".disable_safe_nesting"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::IsA",
    "display_title": "IsA",
    "id": "IsA",
    "url": "Kit.Contract.BuiltInContracts.IsA.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "call-instance_method",
            "properties": [

            ],
            "id": ".call"
          },
          {
            "anchor": "contract_safe?-instance_method",
            "properties": [

            ],
            "id": ".contract_safe?"
          },
          {
            "anchor": "setup-instance_method",
            "properties": [

            ],
            "id": ".setup"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::None",
    "display_title": "None",
    "id": "None",
    "url": "Kit.Contract.BuiltInContracts.None.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "call-instance_method",
            "properties": [

            ],
            "id": ".call"
          },
          {
            "anchor": "setup-instance_method",
            "properties": [

            ],
            "id": ".setup"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::NotEq",
    "display_title": "NotEq",
    "id": "NotEq",
    "url": "Kit.Contract.BuiltInContracts.NotEq.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "call-instance_method",
            "properties": [

            ],
            "id": ".call"
          },
          {
            "anchor": "setup-instance_method",
            "properties": [

            ],
            "id": ".setup"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::Optional",
    "display_title": "Optional",
    "id": "Optional",
    "url": "Kit.Contract.BuiltInContracts.Optional.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "call-instance_method",
            "properties": [

            ],
            "id": ".call"
          },
          {
            "anchor": "setup-instance_method",
            "properties": [

            ],
            "id": ".setup"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::Or",
    "display_title": "Or",
    "id": "Or",
    "url": "Kit.Contract.BuiltInContracts.Or.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "call-instance_method",
            "properties": [

            ],
            "id": ".call"
          },
          {
            "anchor": "setup-instance_method",
            "properties": [

            ],
            "id": ".setup"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::RespondTo",
    "display_title": "RespondTo",
    "id": "RespondTo",
    "url": "Kit.Contract.BuiltInContracts.RespondTo.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "call-instance_method",
            "properties": [

            ],
            "id": ".call"
          },
          {
            "anchor": "contract_safe?-instance_method",
            "properties": [

            ],
            "id": ".contract_safe?"
          },
          {
            "anchor": "setup-instance_method",
            "properties": [

            ],
            "id": ".setup"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::BuiltInContracts::Tupple",
    "display_title": "Tupple",
    "id": "Tupple",
    "url": "Kit.Contract.BuiltInContracts.Tupple.html",
    "headers": [

    ],
    "nodeGroups": [
      {
        "key": "methods-instance",
        "name": "Instance methods",
        "nodes": [
          {
            "anchor": "setup-instance_method",
            "properties": [

            ],
            "id": ".setup"
          }
        ]
      }
    ],
    "group": "Built-in Contracts",
    "css_classes": ""
  },
  {
    "title": "Kit::Contract::Engine",
    "display_title": "Engine",
    "id": "Engine",
    "url": "Kit.Contract.Engine.html",
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