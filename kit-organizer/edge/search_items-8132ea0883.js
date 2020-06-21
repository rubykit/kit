

searchNodes = [
  {
    "type": "class",
    "ref": "Kit.Organizer.Contracts.Result.html#Result-class",
    "title": "Kit::Organizer::Contracts::Result",
    "doc": "Shortcut to specify Tupple[:ok, Hash[values]] || Tupple[:errors, Any] with specific valid keyword arguments. "
  },
  {
    "type": "class",
    "ref": "Kit.Organizer.Error.html#Error-class",
    "title": "Kit::Organizer::Error",
    "doc": "When using contracts on method signatures (through before, after, contract), a Kit::Contract::Error exception is raised when a contract failure happens. "
  },
  {
    "type": "class",
    "ref": "Kit.Organizer.Engine.html#Engine-class",
    "title": "Kit::Organizer::Engine",
    "doc": "The Engine is mainly used to handle all autoloading. "
  },
  {
    "type": "module",
    "ref": "Kit.Organizer.Contracts.html#Contracts-module",
    "title": "Kit::Organizer::Contracts",
    "doc": "Contracts for the project. "
  },
  {
    "type": "module",
    "ref": "Kit.Organizer.html#Organizer-module",
    "title": "Kit::Organizer",
    "doc": "Namespace that holds logic to Organize code flow in your app. "
  },
  {
    "type": "module",
    "ref": "Kit.Organizer.Services.html#Services-module",
    "title": "Kit::Organizer::Services",
    "doc": "Namespace for Kit::Organizer Services. "
  },
  {
    "type": "module",
    "ref": "Kit.Organizer.Services.Callable.html#Callable-module",
    "title": "Kit::Organizer::Services::Callable",
    "doc": "This module makes Organizer extensible. You can add your own behaviours to resolve callables. "
  },
  {
    "type": "module",
    "ref": "Kit.Organizer.Services.Callable.Alias.html#Alias-module",
    "title": "Kit::Organizer::Services::Callable::Alias",
    "doc": "Allows registration of a callable in a local store and reference it by an alias. "
  },
  {
    "type": "module",
    "ref": "Kit.Organizer.Services.Callable.Method.html#Method-module",
    "title": "Kit::Organizer::Services::Callable::Method",
    "doc": "Allows delayed generation of a callable in case of forward declaration. "
  },
  {
    "type": "module",
    "ref": "Kit.Organizer.Services.Callable.Wrap.html#Wrap-module",
    "title": "Kit::Organizer::Services::Callable::Wrap",
    "doc": "Allows to wrap a callable in order to adapt the input & output contexts "
  },
  {
    "type": "module",
    "ref": "Kit.Organizer.Services.Context.html#Context-module",
    "title": "Kit::Organizer::Services::Context",
    "doc": "Handle context operations. "
  },
  {
    "type": "module",
    "ref": "Kit.Organizer.Services.Organize.html#Organize-module",
    "title": "Kit::Organizer::Services::Organize",
    "doc": "Organizer passes the result of a callable to another callable (as long as the result is successfull). It is mostly useful when you need to execute a series of operations resembling a pipeline. You might alredy be familiar with some solutions that deal with this (Promises, Railway Programming, Pipe operators). Kit::Organizer is a flavor of functional interactor. Introduction Describing a list of operations often leads to code that is difficult to follow or nested requires a lot of nesting. For instance: fire_user_created_event(persist_user(validate_password(validate_email({ email: email, password: password })))) # or valid_email? = validate_email(email) valid_password? = validate_password(password) if valid_email? && valid_password? user = persist_user(email: email, password: password) if user fire_user_created_event(user: user) end end With Organizer, this is expressed as: Kit::Organize::Services::Organize.call( list: [ [:alias, :validate_email], [:alias, :validate_password], [:alias, :persist_user], [:alias, :fire_user_created_event], ], ctx: { email: '', password: '', }, ) Context An organizer uses a context. The context contains everything the set of operations need to work. When an operation is called, it can affect the context. Callable A callable is expected to return a result tupple of the following format: [:ok] || [:ok, context_update] || [:error] || [:error, context_update] "
  },
  {
    "type": "module",
    "ref": "Kit.Organizer.Services.Results.html#Results-module",
    "title": "Kit::Organizer::Services::Results",
    "doc": "Utility methods around Contract result payloads. "
  },
  {
    "type": "module",
    "ref": "Kit.html#Kit-module",
    "title": "Top Level Namespace::Kit",
    "doc": "rubocop:disable Style/Documentation "
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Results.html#merge-class_method",
    "title": "Kit::Organizer::Services::Results#merge",
    "doc": "TODO: add indications on how/what to deep merge "
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Results.html#handle_ok-class_method",
    "title": "Kit::Organizer::Services::Results#handle_ok",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Results.html#handle_error-class_method",
    "title": "Kit::Organizer::Services::Results#handle_error",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Organize.html#call-class_method",
    "title": "Kit::Organizer::Services::Organize#call",
    "doc": "Run a list of operations (callable) in order. Each results update the initial ctx which is then sent to the next operation. An operation needs to be a callable, but it can be resolved from other format (see #to_callable) Note: Every operation is expected to return a tupple of the format [:ok] or [:error] with an optional context update ([:ok, { new_ctx_key: 'value' }], [:errors, { errors: [{ detail: 'Error explaination' }], }]). If an :error tupple is returned, the next operations are canceled and call will return. contract Ct::Hash[list: Ct::Operations, ctx: Ct::Optional[Ct::Hash], filter: Ct::Optional[Ct::Or[Ct::Hash[ok: Ct::Array], Ct::Hash[error: Ct::Array]]]] => Ct::ResultTupple "
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Organize.html#sanitize_errors-class_method",
    "title": "Kit::Organizer::Services::Organize#sanitize_errors",
    "doc": "Sanitizes returned errors, if any. contract Ct::Hash[result: Ct::ResultTupple] => Ct::ResultTupple "
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Organize.html#_log-class_method",
    "title": "Kit::Organizer::Services::Organize#_log",
    "doc": "Display debug information when ENV['LOG_ORGANIZER'] is set "
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Context.html#update_context-class_method",
    "title": "Kit::Organizer::Services::Context#update_context",
    "doc": "Performs a 1 level deep merge on the organizer context. "
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Context.html#generate_callable_ctx-class_method",
    "title": "Kit::Organizer::Services::Context#generate_callable_ctx",
    "doc": "Extract needed key from the organizer context to send them to the callable. "
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Callable.Wrap.html#resolve-class_method",
    "title": "Kit::Organizer::Services::Callable::Wrap#resolve",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Callable.Wrap.html#slice-class_method",
    "title": "Kit::Organizer::Services::Callable::Wrap#slice",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Callable.Method.html#resolve-class_method",
    "title": "Kit::Organizer::Services::Callable::Method#resolve",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Callable.Alias.html#resolve-class_method",
    "title": "Kit::Organizer::Services::Callable::Alias#resolve",
    "doc": "ALlows to ? "
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Callable.Alias.html#register-class_method",
    "title": "Kit::Organizer::Services::Callable::Alias#register",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Callable.Alias.html#get-class_method",
    "title": "Kit::Organizer::Services::Callable::Alias#get",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Callable.Alias.html#local_store-class_method",
    "title": "Kit::Organizer::Services::Callable::Alias#local_store",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Callable.Alias.html#create_store-class_method",
    "title": "Kit::Organizer::Services::Callable::Alias#create_store",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Callable.html#store-class_method",
    "title": "Kit::Organizer::Services::Callable#store",
    "doc": "Local store to add custom behaviours. "
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.Services.Callable.html#resolve-class_method",
    "title": "Kit::Organizer::Services::Callable#resolve",
    "doc": "Transform each target to a callable. This is delegated to submodules registered in the local store. "
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.html#call-class_method",
    "title": "Kit::Organizer#call",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.html#call_for_contract-class_method",
    "title": "Kit::Organizer#call_for_contract",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.html#register-class_method",
    "title": "Kit::Organizer#register",
    "doc": "def always(callable, key) callable = to_callable(callable: callable) ->(ctx_in) { [:ok, key: callable.call(ctx_in)] } end "
  },
  {
    "type": "class method",
    "ref": "Kit.Organizer.html#merge-class_method",
    "title": "Kit::Organizer#merge",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Organizer.Error.html#initialize-instance_method",
    "title": "Kit::Organizer::Error.initialize",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Organizer.Contracts.Result.html#setup-instance_method",
    "title": "Kit::Organizer::Contracts::Result.setup",
    "doc": ""
  },
  {
    "type": "instance method",
    "ref": "Kit.Organizer.Contracts.Result.html#call-instance_method",
    "title": "Kit::Organizer::Contracts::Result.call",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Organizer.html#VERSION-constant",
    "title": "Kit::Organizer::VERSION",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Organizer.Services.Callable.html#ResultType-constant",
    "title": "Kit::Organizer::Services::Callable::ResultType",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Organizer.Contracts.html#SuccessStatus-constant",
    "title": "Kit::Organizer::Contracts::SuccessStatus",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Organizer.Contracts.html#ErrorStatus-constant",
    "title": "Kit::Organizer::Contracts::ErrorStatus",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Organizer.Contracts.html#Status-constant",
    "title": "Kit::Organizer::Contracts::Status",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Organizer.Contracts.html#SuccessResultTupple-constant",
    "title": "Kit::Organizer::Contracts::SuccessResultTupple",
    "doc": "TODO: provide smarter SuccessResultTupple to express expected ctx values "
  },
  {
    "type": "constant",
    "ref": "Kit.Organizer.Contracts.html#ErrorResultTupple-constant",
    "title": "Kit::Organizer::Contracts::ErrorResultTupple",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Organizer.Contracts.html#TmpErrorResultTupple-constant",
    "title": "Kit::Organizer::Contracts::TmpErrorResultTupple",
    "doc": "Accepts laxer Error formats that will need to be sanitized "
  },
  {
    "type": "constant",
    "ref": "Kit.Organizer.Contracts.html#ResultTupple-constant",
    "title": "Kit::Organizer::Contracts::ResultTupple",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Organizer.Contracts.html#TmpResultTupple-constant",
    "title": "Kit::Organizer::Contracts::TmpResultTupple",
    "doc": ""
  },
  {
    "type": "extra",
    "ref": "README.html",
    "title": "Kit::Organizer",
    "doc": "Kit::Organizer Kit::Organizer is a flow control library that lets you chain (pipe) operations. To learn more about Kit::Organizer, see Kit::Organizer's documentation. To understand how we think about code organization, see the About Organizers guide. To learn how to use Kit::Organizer in your projects, see the Usage guide. Features TODO: list features. References https://github.com/collectiveidea/interactor http://trailblazer.to/gems/operation/2.0/ https://fsharpforfunandprofit.com/rop/ Copyright & License Copyright (c) 2020, Nathan Appere. Kit::Organizer is licensed under MIT License. "
  },
  {
    "type": "extra",
    "ref": "organizers.html",
    "title": "About Organizers",
    "doc": "About Organizers TODO: explain the need for one validation primitive TODO: explain static typing, pattern matching, dependent types, etc. "
  },
  {
    "type": "extra",
    "ref": "usage.html",
    "title": "Usage",
    "doc": "Usage TODO: add usage. "
  }
];