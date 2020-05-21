require 'awesome_print'

# Helper class to memoize Contract values.
class Kit::Contract::BuiltInContracts::InstanciableType

  # The ctor allows for creation (`args`) && duplication (`state`)
  #
  # All the object state is held in the `@state` instance variable to simplify object cloning.
  def initialize(state: nil, args: nil, bypass_setup: false)
    @state = state || { meta: {} }

    if !bypass_setup
      self.setup(*args)
    end
  end

  # Convenience use of the `[]` operator as an implicit `.new`.
  #
  # Examples
  #```ruby
  # # The two following are identical:
  # Eq[2]
  # Eq.new(args: [2])
  #```
  def self.[](*args)
    new(args: args)
  end

  # Convenience Class method to generate a new Named contract
  def self.named(name)
    self.new(state: { meta: { name: name } }, args: [])
  end

  # Handles initialization logic for `InstanciableType`s
  def setup(*args)
    raise 'Implement me!'
  end

  # Run contracts
  def call
    raise 'Implement me!'
  end

  # Add a meta name to the Contract.
  # This is helpfull for generating Error messages & debugging.
  #
  # ⚠️⚠️ Danger: when called, the Contract is cloned to avoid namig collisions. This is a tradeoffs between obvious side-effects & less obvious ones.
  def named(name)
    new_state = @state.dup
    new_state[:meta] = { name: name }

    self.class.new(state: new_state, bypass_setup: true)
  end

  # Assign `meta` information on the Contract.
  #
  # ⚠️ Warning: It it merged into the existing value.
  def meta(hash)
    @state[:meta].merge!(hash)
    self
  end

  # Meta accessor
  def get_meta
    @state[:meta] || {}
  end

  # When enabled, outputs the Contract arguments when called.
  def debug(args:)
    return if !@state[:meta].dig(:debug)

    name = @state[:meta][:name]
    if name
      name = name.yellow
    else
      name = "Unnamed `#{ self.class.name }`"
    end
    puts "Debut input args for `#{ name }` contract:"
    ap args
  end

end
