# This module makes Organizer extensible. You can add your own behaviours to resolve callables.
module Kit::Organizer::Services::Callable

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Organizer::Contracts

  # Local store to add custom behaviours.
  def self.store
    @store ||= {
      alias:  Kit::Organizer::Services::Callable::Alias.method(:resolve),
      wrap:   Kit::Organizer::Services::Callable::Wrap.method(:resolve),
      method: Kit::Organizer::Services::Callable::Method.method(:resolve),
    }
  end

  ResultType = Ct::Or[Ct::Tupple[Ct::Eq[:ok], Ct::Hash[callable: Ct::Callable]], Ct::ErrorResultTupple]

  contract Ct::Hash[target: Ct::Or[Ct::Callable, Ct::Array[Ct::Symbol]]] => ResultType
  # Transform each target to a callable. This is delegated to submodules registered in the local `store`.
  # @param target A callable or some data that can be transformed to a callable
  # @return A callable
  def self.resolve(target:)
    if target.respond_to?(:call)
      [:ok, callable: target]
    else
      type = target[0]
      if !store[type]
        [:error, "Kit::Organizer could not resolve callable type `#{ type }`"]
      else
        store[type].call(args: target)
      end
    end
  end

end
