

searchNodes = [
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.And.html#And-class",
    "title": "Kit::Contract::BuiltInContracts::And",
    "doc": "Ensure all contracts are successful "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.Any.html#Any-class",
    "title": "Kit::Contract::BuiltInContracts::Any",
    "doc": "Always succeeds. "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.Delayed.html#Delayed-class",
    "title": "Kit::Contract::BuiltInContracts::Delayed",
    "doc": "The actual contract is wrapped in a Callable and resolved on call. This enable circular reference on declaration. "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.Eq.html#Eq-class",
    "title": "Kit::Contract::BuiltInContracts::Eq",
    "doc": "Ensure that the argument equals the saved Contract value "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.In.html#In-class",
    "title": "Kit::Contract::BuiltInContracts::In",
    "doc": "Acts as an enum. Supports Ranges. Examples # The two following are similar: In[:ok, :error] Or[Eq[:ok], Eq[:error]] "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.InstantiableContract.html#InstantiableContract-class",
    "title": "Kit::Contract::BuiltInContracts::InstantiableContract",
    "doc": "Helper class to memoize Contract values. "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.IsA.html#IsA-class",
    "title": "Kit::Contract::BuiltInContracts::IsA",
    "doc": "Ensure that the Contract value is of a given Type. "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.None.html#None-class",
    "title": "Kit::Contract::BuiltInContracts::None",
    "doc": "Ensure no contract is successful "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.NotEq.html#NotEq-class",
    "title": "Kit::Contract::BuiltInContracts::NotEq",
    "doc": "Ensure that the argument is different from the Contract value. "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.Optional.html#Optional-class",
    "title": "Kit::Contract::BuiltInContracts::Optional",
    "doc": "Ensure that Contract is obeyed when not nil. "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.Or.html#Or-class",
    "title": "Kit::Contract::BuiltInContracts::Or",
    "doc": "Ensure at least one contract is successful "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.RespondTo.html#RespondTo-class",
    "title": "Kit::Contract::BuiltInContracts::RespondTo",
    "doc": "Ensure that the object respond_to? a specific method. "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.Tupple.html#Tupple-class",
    "title": "Kit::Contract::BuiltInContracts::Tupple",
    "doc": "Less permissive version of Array. On a Tupple the size is implicit. "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.Error.html#Error-class",
    "title": "Kit::Contract::Error",
    "doc": "When using contracts on method signatures (through before, after, contract) a Kit::Contract::Error exception is raised when a contract failure happens. "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.Engine.html#Engine-class",
    "title": "Kit::Contract::Engine",
    "doc": "The Engine is mainly used to handle all autoloading. "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#Hash-class",
    "title": "Kit::Contract::BuiltInContracts::Hash",
    "doc": "Enable Contracts on Hash instances, on keys themselves, on values themselves, and on elements at specific keys. Supported contract types: of: combo of every_key and every_value as a Hash, more readable for types with: run on the value of specific keys (this is the default when using Hash[data]) every: run on every [key, value] pair every_key: run on every key every_value: run on every value instance: run on the hash instance itself size: instance contract about size Supported internal types of behaviour: every_key: run on every key every_key_value: run on every [key, value] every_value: run on every value keyword_args: run on the value of specific keys instance: run on the hash instance itself Todo: add exemples. "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#Array-class",
    "title": "Kit::Contract::BuiltInContracts::Array",
    "doc": "Enable Contracts on Array instances, and on elements at specific indeces. Supported contract types: of: alias of every_value, for types with: run on the value of specific indeces (this is the default when using Hash[data]) at: here ordering matters every: run on every value instance: run on the hash instance itself size: instance contract about size Supported internal types of behaviour: every_value: run on every value index: run on value at index N instance: run on the hash instance itself Todo: add exemples. "
  },
  {
    "type": "class",
    "ref": "Kit.Contract.BuiltInContracts.Args.html#Args-class",
    "title": "Kit::Contract::BuiltInContracts::Args",
    "doc": "Allows to treat callable arguments as an array "
  },
  {
    "type": "module",
    "ref": "Kit.Contract.BuiltInContracts.html#BuiltInContracts-module",
    "title": "Kit::Contract::BuiltInContracts",
    "doc": "This module contains some Built-in Contracts The easiest way to use them is to include Kit::Contract::BuiltInContracts in your class/module. Basic types Any: succeeds for any argument. Array: ensure that the argument is an ::Array. Index based constraints can also be expressed. See Array doc. Args: variation of Array that lets you define contract for positional arguments. BigDecimal: ensure that the argument is a ::BigDecimal. Boolean: ensure that the argument is true or false. Complex: ensure that the argument is a ::Complex. FalseClass: ensure that the argument is a ::FalseClass. Float: ensure that the argument is a ::Float. Hash: ensure that the argument is a ::Hash. Key based constraints can also be expressed. See Hash doc. Integer: ensure that the argument is a ::Integer. Numeric: ensure that the argument is a ::Numeric. Rational: ensure that the argument is a ::Rational. String: ensure that the argument is a ::String. Symbol: ensure that the argument is a ::Symbol. TrueClass: ensure that the argument is a ::TrueClass. Tupple: variation of Array with an implicit check on size. Operations And: ensure all contracts are successful Optional: ensure that if there is a value, it it not nil Or: ensure at least one contract is successful Dependent types Callable: alias of RespondTo[:call] Enum: alias of In Eq: ensure that the argument equals the given value In: ensure the argument is part of a given collection of objects / values NotEq: ensure that the argument does not equal the given value NotIn: ensure that the argument is not part of a given collection of objects / values RespondTo: ensure that the object respond_to? a specific method "
  },
  {
    "type": "module",
    "ref": "Kit.Contract.Mixin.html#Mixin-module",
    "title": "Kit::Contract::Mixin",
    "doc": "Mixin that add after, before, contract class methods to enforce contracts on method signature. "
  },
  {
    "type": "module",
    "ref": "Kit.Contract.Services.html#Services-module",
    "title": "Kit::Contract::Services",
    "doc": "Namespace for Kit::Contract Services. "
  },
  {
    "type": "module",
    "ref": "Kit.Contract.Services.MethodWrapper.html#MethodWrapper-module",
    "title": "Kit::Contract::Services::MethodWrapper",
    "doc": "Logic to rewrite methods in order to add signature contracts. "
  },
  {
    "type": "module",
    "ref": "Kit.Contract.Services.RubyHelpers.html#RubyHelpers-module",
    "title": "Kit::Contract::Services::RubyHelpers",
    "doc": "Helpers methods to manipulate function signatures. This should be part of the language in one form or another. "
  },
  {
    "type": "module",
    "ref": "Kit.Contract.Services.Runtime.html#Runtime-module",
    "title": "Kit::Contract::Services::Runtime",
    "doc": "Namespace for runtime logic. "
  },
  {
    "type": "module",
    "ref": "Kit.Contract.Services.Store.html#Store-module",
    "title": "Kit::Contract::Services::Store",
    "doc": "Local storage for registered Contracts. TODO: move this to Kit::Store when available "
  },
  {
    "type": "module",
    "ref": "Kit.Contract.Services.Validation.html#Validation-module",
    "title": "Kit::Contract::Services::Validation",
    "doc": "Namespace for Contract validation "
  },
  {
    "type": "module",
    "ref": "Kit.html#Kit-module",
    "title": "Top Level Namespace::Kit",
    "doc": "rubocop:disable Style/Documentation "
  },
  {
    "type": "module",
    "ref": "Kit.Contract.html#Contract-module",
    "title": "Kit::Contract",
    "doc": "rubocop:disable Style/Documentation "
  },
  {
    "type": "module",
    "ref": "Kit.Contract.BuiltInContracts.HashHelper.html#HashHelper-module",
    "title": "Kit::Contract::BuiltInContracts::HashHelper",
    "doc": "Hash validation logic that does not need to live in the Class. "
  },
  {
    "type": "module",
    "ref": "Kit.Contract.BuiltInContracts.ArrayHelper.html#ArrayHelper-module",
    "title": "Kit::Contract::BuiltInContracts::ArrayHelper",
    "doc": "Array validation logic that does not need to live in the Class. "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.Validation.html#valid%3F-class_method",
    "title": "Kit::Contract::Services::Validation#valid?",
    "doc": "contract Hash[contract: Callable, args: Any] => ResultTupple Run a contract & normalize output. "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.Validation.html#all-class_method",
    "title": "Kit::Contract::Services::Validation#all",
    "doc": "contract Hash[contracts: Array.of(Callable), args: Array] => ResultTupple "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.Store.html#add_and_generate_key-class_method",
    "title": "Kit::Contract::Services::Store#add_and_generate_key",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.Store.html#get_next_key-class_method",
    "title": "Kit::Contract::Services::Store#get_next_key",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.Store.html#get-class_method",
    "title": "Kit::Contract::Services::Store#get",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.Store.html#local_store-class_method",
    "title": "Kit::Contract::Services::Store#local_store",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.Runtime.html#instrument-class_method",
    "title": "Kit::Contract::Services::Runtime#instrument",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.Runtime.html#run_contracts!-class_method",
    "title": "Kit::Contract::Services::Runtime#run_contracts!",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.Runtime.html#active%3F-class_method",
    "title": "Kit::Contract::Services::Runtime#active?",
    "doc": "TODO: add different categories of contracts that can be disabled by category "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.RubyHelpers.html#generate_args_in-class_method",
    "title": "Kit::Contract::Services::RubyHelpers#generate_args_in",
    "doc": "Given a callable, attempt to transform args to make it compatible with the signature "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.RubyHelpers.html#get_parameters-class_method",
    "title": "Kit::Contract::Services::RubyHelpers#get_parameters",
    "doc": "Given a callable, get its parameters data "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.RubyHelpers.html#handle_key_args-class_method",
    "title": "Kit::Contract::Services::RubyHelpers#handle_key_args",
    "doc": "Given a hash and some callable parameters, attempts to generate a compatible version of that hash. "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.RubyHelpers.html#parameters_as_signature_to_s-class_method",
    "title": "Kit::Contract::Services::RubyHelpers#parameters_as_signature_to_s",
    "doc": "Given some callable parameters, generate the a callable definition "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.RubyHelpers.html#parameters_as_array_to_s-class_method",
    "title": "Kit::Contract::Services::RubyHelpers#parameters_as_array_to_s",
    "doc": "Given some callable parameters, attempt to generate the array we would have gotten when using a single splat. "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.MethodWrapper.html#wrap-class_method",
    "title": "Kit::Contract::Services::MethodWrapper#wrap",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.MethodWrapper.html#create_alias-class_method",
    "title": "Kit::Contract::Services::MethodWrapper#create_alias",
    "doc": "Rename the method so that we can replace it by a wrapped version that will be able to enforce contracts "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.Services.MethodWrapper.html#create_method_wrapper-class_method",
    "title": "Kit::Contract::Services::MethodWrapper#create_method_wrapper",
    "doc": "Replaces the initial method by a wrapped version that will run contracts before & after the original method. "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.Error.html#initialize-instance_method",
    "title": "Kit::Contract::Error.initialize",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.Error.html#backtrace-instance_method",
    "title": "Kit::Contract::Error.backtrace",
    "doc": "Display informations about the the contract that failed. "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.Error.html#message-instance_method",
    "title": "Kit::Contract::Error.message",
    "doc": "Generates an error message that can be displayed. "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Tupple.html#setup-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Tupple.setup",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.RespondTo.html#setup-instance_method",
    "title": "Kit::Contract::BuiltInContracts::RespondTo.setup",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.RespondTo.html#call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::RespondTo.call",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.RespondTo.html#contract_safe%3F-instance_method",
    "title": "Kit::Contract::BuiltInContracts::RespondTo.contract_safe?",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Or.html#setup-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Or.setup",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Or.html#call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Or.call",
    "doc": "Note: not sure what the correct behaviour is here with safe_nested_call. Should it remove circular reference contracts or pretend they succeeded? Does it make a difference? "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Optional.html#setup-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Optional.setup",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Optional.html#call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Optional.call",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.NotEq.html#setup-instance_method",
    "title": "Kit::Contract::BuiltInContracts::NotEq.setup",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.NotEq.html#call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::NotEq.call",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.None.html#setup-instance_method",
    "title": "Kit::Contract::BuiltInContracts::None.setup",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.None.html#call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::None.call",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.IsA.html#setup-instance_method",
    "title": "Kit::Contract::BuiltInContracts::IsA.setup",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.IsA.html#call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::IsA.call",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.IsA.html#contract_safe%3F-instance_method",
    "title": "Kit::Contract::BuiltInContracts::IsA.contract_safe?",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.InstantiableContract.html#disable_safe_nesting-class_method",
    "title": "Kit::Contract::BuiltInContracts::InstantiableContract#disable_safe_nesting",
    "doc": "Purely for spec purpose. This allows to check that the safe mechanism actually does something. "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.InstantiableContract.html#disable_safe_nesting=-class_method",
    "title": "Kit::Contract::BuiltInContracts::InstantiableContract#disable_safe_nesting=",
    "doc": "Purely for spec purpose. This allows to check that the safe mechanism actually does something. "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.InstantiableContract.html#initialize-instance_method",
    "title": "Kit::Contract::BuiltInContracts::InstantiableContract.initialize",
    "doc": "The ctor allows for creation (args) && duplication (state) All the object state is held in the @state instance variable to simplify object cloning. "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.InstantiableContract.html#[]-class_method",
    "title": "Kit::Contract::BuiltInContracts::InstantiableContract#[]",
    "doc": "Convenience use of the [] operator as an implicit .new. Examples # The two following are identical: Eq[2] Eq.new(args: [2]) "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.InstantiableContract.html#named-class_method",
    "title": "Kit::Contract::BuiltInContracts::InstantiableContract#named",
    "doc": "Convenience Class method to generate a new Named contract "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.InstantiableContract.html#setup-instance_method",
    "title": "Kit::Contract::BuiltInContracts::InstantiableContract.setup",
    "doc": "Handles initialization logic for InstantiableContracts "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.InstantiableContract.html#call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::InstantiableContract.call",
    "doc": "Run contracts "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.InstantiableContract.html#named-instance_method",
    "title": "Kit::Contract::BuiltInContracts::InstantiableContract.named",
    "doc": "Add a meta name to the Contract. This is helpfull for generating Error messages & debugging. ⚠️⚠️ Danger: when called, the Contract is cloned to avoid namig collisions. This is a tradeoffs between obvious side-effects & less obvious ones. "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.InstantiableContract.html#meta-instance_method",
    "title": "Kit::Contract::BuiltInContracts::InstantiableContract.meta",
    "doc": "Assign meta information on the Contract. ⚠️ Warning: It it merged into the existing value. "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.InstantiableContract.html#get_meta-instance_method",
    "title": "Kit::Contract::BuiltInContracts::InstantiableContract.get_meta",
    "doc": "Meta accessor "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.InstantiableContract.html#debug-instance_method",
    "title": "Kit::Contract::BuiltInContracts::InstantiableContract.debug",
    "doc": "When enabled, outputs the Contract arguments when called. "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.InstantiableContract.html#safe_nested_call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::InstantiableContract.safe_nested_call",
    "doc": "Handle circular reference when the contract can self-reference. If a circular reference is detected, skip the contract and let the top level one sort it out. "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.In.html#setup-instance_method",
    "title": "Kit::Contract::BuiltInContracts::In.setup",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.In.html#call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::In.call",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.In.html#beautified_values-instance_method",
    "title": "Kit::Contract::BuiltInContracts::In.beautified_values",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.HashHelper.html#get_keyword_arg_contract-class_method",
    "title": "Kit::Contract::BuiltInContracts::HashHelper#get_keyword_arg_contract",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.HashHelper.html#get_instance_contract-class_method",
    "title": "Kit::Contract::BuiltInContracts::HashHelper#get_instance_contract",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.HashHelper.html#get_every_key_value_contract-class_method",
    "title": "Kit::Contract::BuiltInContracts::HashHelper#get_every_key_value_contract",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.HashHelper.html#get_every_key_contract-class_method",
    "title": "Kit::Contract::BuiltInContracts::HashHelper#get_every_key_contract",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.HashHelper.html#get_every_value_contract-class_method",
    "title": "Kit::Contract::BuiltInContracts::HashHelper#get_every_value_contract",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#setup-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Hash.setup",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Hash.call",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#call-class_method",
    "title": "Kit::Contract::BuiltInContracts::Hash#call",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#add_contract-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Hash.add_contract",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#to_contracts-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Hash.to_contracts",
    "doc": "NOTE: this will only be useful when Organizer can handle any signature "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#of-class_method",
    "title": "Kit::Contract::BuiltInContracts::Hash#of",
    "doc": "Convenience methods. They provide a slighly terser external API to instantiate contracts. "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#with-class_method",
    "title": "Kit::Contract::BuiltInContracts::Hash#with",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#every-class_method",
    "title": "Kit::Contract::BuiltInContracts::Hash#every",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#every_key-class_method",
    "title": "Kit::Contract::BuiltInContracts::Hash#every_key",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#every_value-class_method",
    "title": "Kit::Contract::BuiltInContracts::Hash#every_value",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#instance-class_method",
    "title": "Kit::Contract::BuiltInContracts::Hash#instance",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#meta-class_method",
    "title": "Kit::Contract::BuiltInContracts::Hash#meta",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#size-class_method",
    "title": "Kit::Contract::BuiltInContracts::Hash#size",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#with-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Hash.with",
    "doc": "before Ct::Args[Ct::Hash.of(Ct::NonNil => Ct::Contract)] Add contracts on specific keys. "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#without-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Hash.without",
    "doc": "before Ct::Args[Ct::Array.of(Ct::NonNil)] Add keys that must not exist on the hash. "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#every-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Hash.every",
    "doc": "contract Or[Contract, Array.of(Contract)] "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#every_key-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Hash.every_key",
    "doc": "contract Or[Contract, Array.of(Contract)] "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#every_value-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Hash.every_value",
    "doc": "contract Or[Contract, Array.of(Contract)] "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#of-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Hash.of",
    "doc": "contract Hash.of(Type1 => Type2).size(1) "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#instance-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Hash.instance",
    "doc": "contract Or[Contract, Array.of(Contract)] "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Hash.html#size-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Hash.size",
    "doc": "contract And[Integer, ->(x) { x > 0 }] "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Eq.html#setup-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Eq.setup",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Eq.html#call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Eq.call",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Delayed.html#setup-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Delayed.setup",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Delayed.html#call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Delayed.call",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.ArrayHelper.html#get_index_contract-class_method",
    "title": "Kit::Contract::BuiltInContracts::ArrayHelper#get_index_contract",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.ArrayHelper.html#get_instance_contract-class_method",
    "title": "Kit::Contract::BuiltInContracts::ArrayHelper#get_instance_contract",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.ArrayHelper.html#get_every_value_contract-class_method",
    "title": "Kit::Contract::BuiltInContracts::ArrayHelper#get_every_value_contract",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#setup-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Array.setup",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Array.call",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#call-class_method",
    "title": "Kit::Contract::BuiltInContracts::Array#call",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#add_contract-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Array.add_contract",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#to_contracts-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Array.to_contracts",
    "doc": "NOTE: this will only be useful when Organizer can handle any signature "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#at-class_method",
    "title": "Kit::Contract::BuiltInContracts::Array#at",
    "doc": "Convenience methods. They provide a slighly terser external API to instantiate contracts. "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#of-class_method",
    "title": "Kit::Contract::BuiltInContracts::Array#of",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#with-class_method",
    "title": "Kit::Contract::BuiltInContracts::Array#with",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#every-class_method",
    "title": "Kit::Contract::BuiltInContracts::Array#every",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#instance-class_method",
    "title": "Kit::Contract::BuiltInContracts::Array#instance",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#meta-class_method",
    "title": "Kit::Contract::BuiltInContracts::Array#meta",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#size-class_method",
    "title": "Kit::Contract::BuiltInContracts::Array#size",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#of-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Array.of",
    "doc": "contract Array.of(Contract).size(1) "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#at-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Array.at",
    "doc": "contract Hash.of(And[Integer, Gt[0]] => Contract) "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#with-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Array.with",
    "doc": "Position matters on this one contract Array.of(Contract) "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#size-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Array.size",
    "doc": "contract And[Integer, ->(x) { x > 0 }] "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#every-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Array.every",
    "doc": "contract Array.of(Contract).size(1) "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Array.html#instance-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Array.instance",
    "doc": "contract Or[Contract, Array.of(Contract)] "
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.Args.html#call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::Args.call",
    "doc": "Receives the list of arguments as an array, and forwards it the first argument. "
  },
  {
    "type": "class method",
    "ref": "Kit.Contract.BuiltInContracts.Any.html#call-class_method",
    "title": "Kit::Contract::BuiltInContracts::Any#call",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.And.html#setup-instance_method",
    "title": "Kit::Contract::BuiltInContracts::And.setup",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Contract.BuiltInContracts.And.html#call-instance_method",
    "title": "Kit::Contract::BuiltInContracts::And.call",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.html#VERSION-constant",
    "title": "Kit::Contract::VERSION",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.Services.MethodWrapper.html#METHOD_PREFIX-constant",
    "title": "Kit::Contract::Services::MethodWrapper::METHOD_PREFIX",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#TrueClass-constant",
    "title": "Kit::Contract::BuiltInContracts::TrueClass",
    "doc": "Ensure that the argument is a ::TrueClass. "
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#Symbol-constant",
    "title": "Kit::Contract::BuiltInContracts::Symbol",
    "doc": "Ensure that the argument is a ::Symbol. "
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#String-constant",
    "title": "Kit::Contract::BuiltInContracts::String",
    "doc": "Ensure that the argument is a ::String. "
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#Rational-constant",
    "title": "Kit::Contract::BuiltInContracts::Rational",
    "doc": "Ensure that the argument is a ::Rational. "
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#Numeric-constant",
    "title": "Kit::Contract::BuiltInContracts::Numeric",
    "doc": "Ensure that the argument is a ::Numeric. "
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#Nil-constant",
    "title": "Kit::Contract::BuiltInContracts::Nil",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#NonNil-constant",
    "title": "Kit::Contract::BuiltInContracts::NonNil",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#Integer-constant",
    "title": "Kit::Contract::BuiltInContracts::Integer",
    "doc": "Ensure that the argument is an ::Integer. "
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#Int-constant",
    "title": "Kit::Contract::BuiltInContracts::Int",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#PositiveInteger-constant",
    "title": "Kit::Contract::BuiltInContracts::PositiveInteger",
    "doc": "Ensure that the Contract argument is a positive ::Integer. "
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#PosInt-constant",
    "title": "Kit::Contract::BuiltInContracts::PosInt",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#NegativeInteger-constant",
    "title": "Kit::Contract::BuiltInContracts::NegativeInteger",
    "doc": "Ensure that the Contract argument is a negative ::Integer. "
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#NegInt-constant",
    "title": "Kit::Contract::BuiltInContracts::NegInt",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#Float-constant",
    "title": "Kit::Contract::BuiltInContracts::Float",
    "doc": "Ensure that the argument is a ::Float. "
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#FalseClass-constant",
    "title": "Kit::Contract::BuiltInContracts::FalseClass",
    "doc": "Ensure that the argument is a ::FalseClass. "
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#Complex-constant",
    "title": "Kit::Contract::BuiltInContracts::Complex",
    "doc": "Ensure that the argument is a ::Complex. "
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#Callable-constant",
    "title": "Kit::Contract::BuiltInContracts::Callable",
    "doc": "Ensure the argument respond_to(:call) "
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#Callables-constant",
    "title": "Kit::Contract::BuiltInContracts::Callables",
    "doc": "Ensure the argument is an Array of Callable "
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#Boolean-constant",
    "title": "Kit::Contract::BuiltInContracts::Boolean",
    "doc": "Ensure that the argument is true or false. "
  },
  {
    "type": "constant",
    "ref": "Kit.Contract.BuiltInContracts.html#BigDecimal-constant",
    "title": "Kit::Contract::BuiltInContracts::BigDecimal",
    "doc": "Ensure that the argument is a ::BigDecimal. "
  },
  {
    "type": "extra",
    "ref": "README.html",
    "title": "Kit::Contract",
    "doc": "Kit::Contract Kit::Contract allows you to codify expectations about your data. It can be applied to functions pre & post conditions, user input validation, etc. It provides a single validation primitive for all data. To learn more about Kit::Contract, see Kit::Contract's documentation. To understand how we think about Contracts, see the Why Contracts? guide. To learn how to use Kit::Contract in your projects, see the Usage guide. Features Method pre / post conditions Named contracts Built-in \"types\" contracts References Wikipedia introduction to DbC Ruby: Contracts (Egon Schiele) Elixir: ExContracts (JDUnity) Elixir: Norm (Chris Keathley) Elixir: Contracts for Building Reliable Systems (Chris Keathley) Copyright & License Copyright (c) 2020, Nathan Appere. Kit::Contract is licensed under MIT License. "
  },
  {
    "type": "extra",
    "ref": "usage.html",
    "title": "Usage",
    "doc": "Usage TODO: add usage. "
  },
  {
    "type": "extra",
    "ref": "why_contracts.html",
    "title": "Why Contracts?",
    "doc": "Why Contracts? Code contracts allow you make some assertions about your code, and then checks them to make sure they hold. TODO: explain the need for one validation primitive TODO: explain static typing, pattern matching, dependent types, etc. "
  }
];