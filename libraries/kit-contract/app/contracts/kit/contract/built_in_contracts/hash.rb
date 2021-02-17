module Kit::Contract::BuiltInContracts

  # Hash validation logic that does not need to live in the Class.
  module HashHelper

    def self.get_keyword_arg_contract(key:, contract:)
      ->(*args, **kwargs) do
        kwargs = args[0] if !kwargs || kwargs.empty? && args[0]&.is_a?(::Hash)

        # TODO: add key in errors?
        Kit::Contract::Services::Validation.valid?(contract: contract, parameters: { args: [kwargs[key]] })
      end
    end

    def self.get_instance_contract(contract:)
      ->(*args, **kwargs) do
        kwargs = args[0] if !kwargs || kwargs.empty? && args[0]&.is_a?(::Hash)

        Kit::Contract::Services::Validation.valid?(contract: contract, parameters: { args: [kwargs] })
      end
    end

    def self.get_every_key_value_contract(contract:)
      ->(*args, **kwargs) do
        kwargs.each do |key, value|
          kwargs = args[0] if !kwargs || kwargs.empty? && args[0]&.is_a?(::Hash)

          result       = Kit::Contract::Services::Validation.valid?(contract: contract, parameters: { args: [key, value] })
          status, _ctx = result
          return result if status == :error
        end
        [:ok]
      end
    end

    def self.get_every_key_contract(contract:)
      ->(*args, **kwargs) do
        kwargs.each_key do |key|
          kwargs = args[0] if !kwargs || kwargs.empty? && args[0]&.is_a?(::Hash)

          result       = Kit::Contract::Services::Validation.valid?(contract: contract, parameters: { args: [key] })
          status, _ctx = result
          return result if status == :error
        end
        [:ok]
      end
    end

    def self.get_every_value_contract(contract:)
      ->(*args, **kwargs) do
        kwargs.each_value do |value|
          kwargs = args[0] if !kwargs || kwargs.empty? && args[0]&.is_a?(::Hash)

          result       = Kit::Contract::Services::Validation.valid?(contract: contract, parameters: { args: [value] })
          status, _ctx = result
          return result if status == :error
        end
        [:ok]
      end
    end

  end

  # Enable Contracts on Hash instances, on keys themselves, on values themselves, and on elements at specific keys.
  #
  # ## Supported contract types:
  # - `of`:          combo of `every_key` and `every_value` as a Hash, more readable for types
  # - `with`:        run on the value of specific keys (this is the default when using Hash[data])
  # - `every`:       run on every [key, value] pair
  # - `every_key`:   run on every key
  # - `every_value`: run on every value
  # - `instance`:    run on the hash instance itself
  # - `size`:        instance contract about size
  #
  # ## Supported internal types of behaviour:
  # - `every_key`:       run on every key
  # - `every_key_value`: run on every [key, value]
  # - `every_value`:     run on every value
  # - `keyword_args`:    run on the value of specific keys
  # - `instance`:        run on the hash instance itself
  #
  # ## Todo: add exemples.
  #
  class Hash < Kit::Contract::BuiltInContracts::InstantiableContract

    def setup(keyword_args_contracts = nil)
      @state[:contracts_list] = []

      instance(IsA[::Hash], safe: true)
      with(keyword_args_contracts || [])
    end

    def call(*args, **kwargs)
      return self if !Kit::Contract::Services::Runtime.active?

      parameters = { args: args || [], kwargs: kwargs || {}, }

      debug(parameters: parameters)

      safe_nested_call(list: @state[:contracts_list], parameters: parameters, contract: self) do |local_contract|
        #status, ctx = result = local_contract.call(*args)
        status, ctx = result = Kit::Contract::Services::Validation.valid?(contract: local_contract, parameters: parameters)
        if status == :error
          if ctx[:contracts_stack]
            ctx[:contracts_stack] << contract
          end
          return result
        end
      end

      [:ok]
    end

    def self.call(*args, **kwargs)
      return self if !Kit::Contract::Services::Runtime.active?

      IsA[::Hash].call(*args, **kwargs)
    end

    def add_contract(contract:, safe: false)
      el = safe ? { contract: contract, safe: true } : contract
      @state[:contracts_list] << el
    end

    # NOTE: this will only be useful when Organizer can handle any signature
    def to_contracts
      @state[:contracts_list]
    end

    # Convenience methods. They provide a slighly terser external API to instantiate contracts.
    def self.of(*contracts);          self.new.of(*contracts);          end

    def self.with(*contracts);        self.new.with(*contracts);        end

    def self.every(*contracts);       self.new.every(*contracts);       end

    def self.every_key(*contracts);   self.new.every_key(*contracts);   end

    def self.every_value(*contracts); self.new.every_value(*contracts); end

    def self.instance(*contracts);    self.new.instance(*contracts);    end

    def self.meta(opts);              self.new.meta(opts);              end

    def self.size(size);              self.new.size(size);              end

    # before Ct::Args[Ct::Hash.of(Ct::NonNil => Ct::Contract)]
    # Add contracts on specific keys.
    def with(contracts, safe: false)
      return self if !Kit::Contract::Services::Runtime.active?

      contracts.each do |key, contract|
        if !contract.respond_to?(:call)
          raise 'Invalid contract usage: Hash.with values must be contracts (callable).'
        end

        add_contract(contract: HashHelper.get_keyword_arg_contract(key: key, contract: contract), safe: safe)
      end

      self
    end

    # before Ct::Args[Ct::Array.of(Ct::NonNil)]
    # Add keys that must not exist on the hash.
    def without(keys, safe: false)
      return self if !Kit::Contract::Services::Runtime.active?

      keys = [keys] if !keys.is_a?(Array)

      keys.each do |key|
        instance(->(hash) { !hash.key?(key) }, safe: true)
      end

      self
    end

    # contract Or[Contract, Array.of(Contract)]
    def every(contracts, safe: false)
      return self if !Kit::Contract::Services::Runtime.active?

      [contracts]
        .flatten
        .each do |contract|
          if !contract.respond_to?(:call)
            raise 'Invalid contract usage: Hash.every_key values must be contracts (callable).'
          end

          # TODO: check signature compatibility here ?

          add_contract(contract: HashHelper.get_every_key_value_contract(contract: contract), safe: safe)
        end

      self
    end

    # contract Or[Contract, Array.of(Contract)]
    def every_key(contracts, safe: false)
      return self if !Kit::Contract::Services::Runtime.active?

      [contracts]
        .flatten
        .each do |contract|
          if !contract.respond_to?(:call)
            raise 'Invalid contract usage: Hash.every_key values must be contracts (callable).'
          end

          add_contract(contract: HashHelper.get_every_key_contract(contract: contract), safe: safe)
        end

      self
    end

    # contract Or[Contract, Array.of(Contract)]
    def every_value(contracts, safe: false)
      return self if !Kit::Contract::Services::Runtime.active?

      [contracts]
        .flatten
        .each do |contract|
          if !contract.respond_to?(:call)
            raise 'Invalid contract usage: Hash.every_value values must be contracts (callable).'
          end

          add_contract(contract: HashHelper.get_every_value_contract(contract: contract), safe: safe)
        end

      self
    end

    # contract Hash.of(Type1 => Type2).size(1)
    def of(contracts, safe: false)
      return self if !Kit::Contract::Services::Runtime.active?

      if contracts.keys.size > 1
        raise 'Invalid contract usage: Hash.every can only accept one key <> value.'
      end

      every_key(contracts.keys.first)
      every_value(contracts.values.first)

      self
    end

    # contract Or[Contract, Array.of(Contract)]
    def instance(contracts, safe: false)
      return self if !Kit::Contract::Services::Runtime.active?

      [contracts]
        .flatten
        .each do |contract|
          if !contract.respond_to?(:call)
            raise 'Invalid contract usage: Hash.instance values must be contracts (callable).'
          end

          add_contract(contract: HashHelper.get_instance_contract(contract: contract), safe: safe)
        end

      self
    end

    # contract And[Integer, ->(x) { x > 0 }]
    def size(size)
      return self if !Kit::Contract::Services::Runtime.active?

      instance(->(i) { i.size == size }, safe: true)
      self
    end

  end

end
