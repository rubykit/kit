require 'awesome_print'

# Helper class to memoize Contract values.
class Kit::Contract::BuiltInContracts::InstantiableContract

  class << self

    # Purely for spec purpose. This allows to check that the safe mechanism actually does something.
    attr_accessor :disable_safe_nesting

  end

  # The ctor allows for creation (`args`) && duplication (`state`)
  #
  # All the object state is held in the `@state` instance variable to simplify object cloning.
  def initialize(state: nil, args: nil, bypass_setup: false)
    @state = state || { meta: {} }

    return if !Kit::Contract::Services::Runtime.active?
    return if bypass_setup

    self.setup(*args)
  end

  # Convenience use of the `[]` operator as an implicit `.new`.
  #
  # Examples
  #```ruby
  # # The two following are identical:
  # Eq[2]
  # Eq.new(args: [2])
  #```
  def self.[](*args, **kwargs)
    args << kwargs if kwargs && !kwargs.empty?
    new(args: args)
  end

  # Convenience Class method to generate a new Named contract
  def self.named(name)
    self.new(state: { meta: { name: name } }, args: [])
  end

  # Handles initialization logic for `InstantiableContract`s
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
  def get_meta # rubocop:disable Naming/AccessorMethodName
    @state[:meta] || {}
  end

  # When enabled, outputs the Contract arguments when called.
  def debug(parameters:)
    return if !@state[:meta][:debug]

    name = @state[:meta][:name]
    if name
      name = name.yellow
    else
      name = "Unnamed `#{ self.class.name }`"
    end
    puts "Debut input args for `#{ name }` contract:"
    ap parameters
  end

  # Handle circular reference when the contract can self-reference.
  # If a circular reference is detected, skip the contract and let the top level one sort it out.
  def safe_nested_call(list:, parameters:, contract:)
    # Purely for spec purpose. This allows to check that the safe mechanism actually does something.
    if self.class.disable_safe_nesting == true
      list.each { |local_contract| yield(local_contract.is_a?(Hash) ? local_contract[:contract] : local_contract) }
      return
    end

    @cache_ref ||= Concurrent::ThreadLocalVar.new({})
    cache_ref = @cache_ref
    cache_removal = []

    result = list.filter_map do |local_contract|
      safe = false
      if local_contract.is_a?(Hash)
        safe           = local_contract[:safe] || false
        local_contract = local_contract[:contract]
      end

      if !safe && local_contract.respond_to?(:contract_safe?)
        safe = local_contract.contract_safe?
      end

      if safe
        yield local_contract
      else
        contract_oid   = local_contract.object_id
        parameters_oid = parameters[:args].map(&:object_id)

        if parameters[:kwargs] && !parameters[:kwargs].empty?
          key = parameters[:kwargs].map { |k, v| "#{ k.object_id }:#{ v.object_id }" }.join('|')
          parameters_oid << key
        end

        #parameters_oid = parameters_oid.join(',')

        cache_value = cache_ref.value
        cache_value[contract_oid] ||= {}

        if cache_value[contract_oid].include?(parameters_oid)
          [:ok]
        else
          cache_value[contract_oid][parameters_oid] = parameters_oid

          cache_ref.value = cache_value

          cache_removal << [contract_oid, parameters_oid]

          yield local_contract
        end
      end
    end

    # Remove reference we saved at this level
    cache_value = cache_ref.value
    cache_removal.each do |contract_oid, parameters_oid|
      cache_value[contract_oid].delete(parameters_oid)
    end
    cache_ref.value = cache_value

    result
  end

end
