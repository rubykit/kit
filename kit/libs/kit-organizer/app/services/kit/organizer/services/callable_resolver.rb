module Kit::Organizer::Services::CallableResolver
  include Kit::Contract
  Ct = Kit::Organizer::Contracts

  def self.store
    @store ||= {
      alias:  Kit::Organizer::Services::CallableResolver::Alias.method(:resolve),
      wrap:   Kit::Organizer::Services::CallableResolver::Wrap.method(:resolve),
      method: Kit::Organizer::Services::CallableResolver::Method.method(:resolve),
    }
  end

  resultType = Ct::Or[Ct::Tupple[Ct::Eq[:ok], Ct::Hash[callable: Ct::Callable]], Ct::ErrorResultTupple]

  contract Ct::Hash[callable: Ct::Or[Ct::Callable, Ct::Array[Ct::Symbol]] => resultType
  def self.resolve(callable:)
    if callable.respond_to?(:call)
      [:ok, callable: callable]
    else
      type, args = callable
      if !store[type]
        [:error, "Kit::Organizer could not resolve callable type `#{type}`"]
      else
        store[type].call(args: args)
      end
    end
  end

end