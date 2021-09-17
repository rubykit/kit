# Allows registration of a callable in a local store with an alias name.
# It can be used later by using the alias.
#
# ## Registering the alias
#
# ```ruby
# callable = ->(counter:) { [:ok, counter: counter + 1]}
# Kit::Organizer::Services::Callable::Alias.register(id: :increment_counter, target: callable)
# ```
#
# ## Using the alias
#
# ```ruby
# Kit::Organize::Services::Organize.call(
#   list: [
#     [:alias, :increment_counter],
#   ],
#   ctx: { counter: 1 },
# )
# ```
module Kit::Organizer::Services::Callable::Alias

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Organizer::Contracts

  # Resolves `alias_name` to the registered `:callable`
  # @note The expected format is `[:alias, alias_name]`.
  contract Ct::Hash[args: Ct::Tupple[Ct::Eq[:alias], Ct::Symbol]]
  def self.resolve(args:, store: nil)
    _, alias_name = args
    store ||= local_store

    [:ok, callable: get(id: alias_name, store: store)]
  end

  # Saves a `:target` in the alias store, identified by `:id`
  contract Ct::Hash[id: Ct::Symbol, target: Ct::Callable]
  def self.register(id:, target:, store: nil)
    store ||= local_store

    store[id.to_sym] = {
      target: target,
    }
  end

  # Get the alias identified with `:id`
  contract Ct::Hash[id: Ct::Symbol]
  def self.get(id:, store: nil)
    store ||= local_store
    record = store[id.to_sym]

    if !record
      raise "Kit::Organizer::Services::Callable::Alias | unknown alias `#{ id }`"
    end

    record[:target]
  end

  # Create a store to save organizer's aliases
  def self.create_store
    {}
  end

  # Default store when not specified as a parameter
  def self.local_store
    @local_store ||= create_store
  end

end
