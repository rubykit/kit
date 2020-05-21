module Kit::Contract::BuiltInContracts

  # Hash validation logic that does not need to live in the Class.
  module HashHelper

    def self.run_contracts(list:, args:, contract:)
      list.each do |local_contract|
        status, ctx = result = local_contract.call(*args)
        if status == :error
          if ctx[:contracts_stack]
            ctx[:contracts_stack] << contract
          end
          return result
        end
      end

      [:ok]
    end

    def self.get_keyword_arg_contract(key:, contract:)
      ->(hash) do
        result      = Kit::Contract::Services::Validation.valid?(contract: contract, args: [hash[key]])
        status, ctx = result

        if status == :error
          ctx[:contract_error]
        end

        result
      end
    end

    def self.get_instance_contract(contract:)
      ->(hash) do
        Kit::Contract::Services::Validation.valid?(contract: contract, args: [hash])
      end
    end

    def self.get_every_key_value_contract(contract:)
      ->(hash) do
        hash.each do |key, value|
          result       = Kit::Contract::Services::Validation.valid?(contract: contract, args: [key, value])
          status, _ctx = result
          return result if status == :error
        end
        [:ok]
      end
    end

    def self.get_every_key_contract(contract:)
      ->(hash) do
        hash.each_key do |key|
          result       = Kit::Contract::Services::Validation.valid?(contract: contract, args: [key])
          status, _ctx = result
          return result if status == :error
        end
        [:ok]
      end
    end

    def self.get_every_value_contract(contract:)
      ->(hash) do
        hash.each_value do |value|
          result       = Kit::Contract::Services::Validation.valid?(contract: contract, args: [value])
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
  class Hash < Kit::Contract::BuiltInContracts::InstanciableType

    def setup(keyword_args_contracts = nil)
      @state[:contracts_list] = []

      instance(IsA[::Hash])
      with(keyword_args_contracts || [])
    end

    def call(*args)
      debug(args: args)
      HashHelper.run_contracts(list: @state[:contracts_list], args: args, contract: self)
    end

    def self.call(*value)
      IsA[::Hash].call(*value)
    end

    def add_contract(contract)
      @state[:contracts_list] << contract
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

    # contract Hash.of(Any => Contract)
    def with(contracts)
      contracts.each do |key, contract|
        if !contract.respond_to?(:call)
          raise 'Invalid contract usage: Hash.with values must be contracts (callable).'
        end

        add_contract HashHelper.get_keyword_arg_contract(key: key, contract: contract)
      end

      self
    end

    # contract Or[Contract, Array.of(Contract)]
    def every(contracts)
      [contracts]
        .flatten
        .each do |contract|
          if !contract.respond_to?(:call)
            raise 'Invalid contract usage: Hash.every_key values must be contracts (callable).'
          end

          # TODO: check signature compatibility here ?

          add_contract HashHelper.get_every_key_value_contract(contract: contract)
        end

      self
    end

    # contract Or[Contract, Array.of(Contract)]
    def every_key(contracts)
      [contracts]
        .flatten
        .each do |contract|
          if !contract.respond_to?(:call)
            raise 'Invalid contract usage: Hash.every_key values must be contracts (callable).'
          end

          add_contract HashHelper.get_every_key_contract(contract: contract)
        end

      self
    end

    # contract Or[Contract, Array.of(Contract)]
    def every_value(contracts)
      [contracts]
        .flatten
        .each do |contract|
          if !contract.respond_to?(:call)
            raise 'Invalid contract usage: Hash.every_value values must be contracts (callable).'
          end

          add_contract HashHelper.get_every_value_contract(contract: contract)
        end

      self
    end

    # contract Hash.of(Type1 => Type2).size(1)
    def of(contracts)
      if contracts.keys.size > 1
        raise 'Invalid contract usage: Hash.every can only accept one key <> value.'
      end

      every_key(contracts.keys.first)
      every_value(contracts.values.first)

      self
    end

    # contract Or[Contract, Array.of(Contract)]
    def instance(contracts)
      [contracts]
        .flatten
        .each do |contract|
          if !contract.respond_to?(:call)
            raise 'Invalid contract usage: Hash.instance values must be contracts (callable).'
          end

          add_contract HashHelper.get_instance_contract(contract: contract)
        end

      self
    end

    # contract And[Integer, ->(x) { x > 0 }]
    def size(size)
      instance(->(i) { i.size == size })
      self
    end

  end

end
