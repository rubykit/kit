module Kit::Contract::Types

=begin
  Contract types:
    of:          alias of `every`, for types
    with:        run on the value of specific keys (this is the default when using Hash[data])

    every:       run on every [key, value]
    every_key:   run on every key
    every_value: run on every value
    instance:    run on the hash instance itself

    size:        instance contract about size
=end

=begin
  Internal types of behaviour:
    every_key:       run on every key
    every_key_value: run on every [key, value]
    every_value:     run on every value
    keyword_args:    run on the value of specific keys
    instance:        run on the hash instance itself
=end

  module HashHelper

    def self.run_contracts(list:, args:)
      list.each do |contract|
        status, _ = result = contract.call(*args)
        return result if status == :error
      end

      [:ok]
    end

    def self.get_keyword_arg_contract(key:, contract:)
      ->(hash) do
        Kit::Contract::Services::Validation.valid?(contract: contract, args: [hash[key]])
      end
    end

    def self.get_instance_contract(contract:)
      ->(instance) do
        Kit::Contract::Services::Validation.valid?(contract: contract, args: [instance])
      end
    end

    def self.get_every_key_value_contract(contract:)
      ->(hash) do
        hash.each do |key, value|
          result = status, _ = Kit::Contract::Services::Validation.valid?(contract: contract, args: [{ key: key, value: value }])
          return result if status == :error
        end
        [:ok]
      end
    end

    def self.get_every_key_contract(contract:)
      ->(hash) do
        hash.keys.each do |key|
          result = status, _ = Kit::Contract::Services::Validation.valid?(contract: contract, args: [{ key: key }])
          return result if status == :error
        end
        [:ok]
      end
    end

    def self.get_every_value_contract(contract:)
      ->(hash) do
        hash.values.each do |key|
          result = status, ctx = Kit::Contract::Services::Validation.valid?(contract: contract, args: [{ value: key }])
          return result if status == :error
        end
        [:ok]
      end
    end
  end

  class Hash < InstanciableType

    def initialize(keyword_args_contracts = nil)
      @contracts_list = []

      instance(IsA[::Hash])
      with(keyword_args_contracts || [])
    end

    def call(*args)
      HashHelper.run_contracts(list: @contracts_list, args: args)
    end

    def add_contract(contract)
      @contracts_list << contract
    end

    # NOTE: this will only be useful when Organizer can handle any signature
    def to_contracts
      @contracts_list
    end

    # Convenience methods. They provide a slighly terser external API.
    def self.of(contracts);          self.new.of(contracts);          end;
    def self.with(contracts);        self.new.with(contracts);        end;
    def self.every(contracts);       self.new.every(contracts);       end;
    def self.every_key(contracts);   self.new.every_key(contracts);   end;
    def self.every_value(contracts); self.new.every_value(contracts); end;
    def self.instance(contracts);    self.new.instance(contracts);    end;
    def self.size(size);             self.new.size(size);             end;


    # contract Hash.of(Any => Contract)
    def with(contracts)
      contracts.each do |key, contract|
        if !contract.respond_to?(:call)
          raise "Invalid contract usage: Hash.with values must be contracts (callable)"
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
            raise "Invalid contract usage: Hash.every_key values must be contracts (callable)"
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
            raise "Invalid contract usage: Hash.every_key values must be contracts (callable)"
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
            raise "Invalid contract usage: Hash.every_value values must be contracts (callable)"
          end

          add_contract HashHelper.get_every_value_contract(contract: contract)
        end

      self
    end

    # contract Hash.of(Type1 => Type2).size(1)
    def of(contracts)
      if contracts.keys.size > 1
        raise "Invalid contract usage: Hash.every can only accept one key <> value"
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
            raise "Invalid contract usage: Hash.instance values must be contracts (callable)"
          end

          add_contract HashHelper.get_instance_contract(contract: contract)
        end

      self
    end

    # contract And[Integer, ->(x) { x > 0 }]
    def size(size)
      instance(->(i) { i.size == size })
    end

  end

end