# Allows registration of a callable in a local store and reference it by an alias.
module Kit::Organizer::Services::Callable::Alias

  include Kit::Contract::Mixin
  # @hide = true
  Ct = Kit::Organizer::Contracts

  # ALlows to ?
  # @note The expected format is `[:alias, :alias_name]`.
  contract Ct::Hash[args: Ct::Tupple[Ct::Eq[:alias], Ct::Symbol]]
  def self.resolve(store: local_store, args:)
    _, alias_name = args

    [:ok, callable: get(id: alias_name, store: store)]
  end

  contract Ct::Hash[id: Ct::Symbol, target: Ct::Callable]
  def self.register(store: local_store, id:, target:)
    store[id.to_sym] = {
      target: target,
    }
  end

  contract Ct::Hash[id: Ct::Symbol]
  def self.get(store: local_store, id:)
    record = store[id.to_sym]

    if !record
      raise "Kit::Organizer::Services::Callable::Alias | unknown alias `#{ id }`"
    end

    record[:target]
  end

  def self.local_store
    @local_store ||= create_store
  end

  def self.create_store
    {}
  end

end
