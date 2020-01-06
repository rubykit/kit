# Allows delayed generation of a callable in case of forward declaration.
module Kit::Organizer::Services::Callable::Method
  include Kit::Contract
  Ct = Kit::Organizer::Contracts

  # @note The expected format is `[:method, 'ModuleName', 'method_name']`. `ModuleName` can be a reference, string or symbol. `method_name` can be a string or symbol.
  # @example Generating a callable from a tupple of ModuleName && method_name
  #   resolve(args: [:'AuthenticationModule', 'sign_in']) => Proc(AuthenticationModule#sign_in)
  #   resolve(args: ['AuthenticationModule', 'sign_in']) => Proc(AuthenticationModule#sign_in)
  #   resolve(args: [AuthenticationModule, :sign_in]) => Proc(AuthenticationModule#sign_in)
  contract Ct::Hash[args: Ct::Tupple[Ct::Eq[:method], Ct::Any, Ct::Or[Ct::String, Ct::Symbol]]]
  def self.resolve(args:)
    _, class_target, method_target = args

    if class_target.is_a?(String) || class_target.is_a?(Symbol)
      class_target = class_target.to_s.constantize
    end

    if !method_target.is_a?(Symbol)
      method_target = method_target.to_sym
    end

    [:ok, callable: class_target.method(method_target)]
  end

end