module Kit::Contract::BuiltInContracts

  # Array validation logic that does not need to live in the Class.
  module ArrayHelper

    def self.get_index_contract(contract:, index:)
      ->(array) do
        Kit::Contract::Services::Validation.valid?(contract: contract, args: [array[index]])
      end
    end

    def self.get_instance_contract(contract:)
      ->(array) do
        Kit::Contract::Services::Validation.valid?(contract: contract, args: [array])
      end
    end

    def self.get_every_value_contract(contract:)
      ->(array) do
        array.each do |value|
          result       = Kit::Contract::Services::Validation.valid?(contract: contract, args: [value])
          status, _ctx = result
          return result if status == :error
        end
        [:ok]
      end
    end
  end

  # Enable Contracts on Array instances, and on elements at specific indeces.
  #
  # ## Supported contract types:
  # - `of`:          alias of `every_value`, for types
  # - `with`:        run on the value of specific indeces (this is the default when using Hash[data])
  # - `at`:          here ordering matters
  # - `every`:       run on every value
  # - `instance`:    run on the hash instance itself
  # - `size`:        instance contract about size
  #
  # ## Supported internal types of behaviour:
  # - `every_value`: run on every value
  # - `index`:       run on value at index N
  # - `instance`:    run on the hash instance itself
  #
  # ## Todo: add exemples.
  #
  class Array < Kit::Contract::BuiltInContracts::InstanciableType

    def setup(*index_contracts)
      @state[:contracts_list] = []

      instance(IsA[::Array])
      with(index_contracts || [])
    end

    def call(*args)
      debug(args: args)

      safe_nested_call(list: @state[:contracts_list], args: args, contract: self) do |local_contract|
        #status, ctx = result = local_contract.call(*args)
        status, ctx = result = Kit::Contract::Services::Validation.valid?(contract: local_contract, args: args)
        if status == :error
          if ctx[:contracts_stack]
            ctx[:contracts_stack] << contract
          end
          return result
        end
      end

      [:ok]
    end

    def self.call(*args)
      IsA[::Array].call(*args)
    end

    def add_contract(contract)
      @state[:contracts_list] << contract
    end

    # NOTE: this will only be useful when Organizer can handle any signature
    def to_contracts
      @state[:contracts_list]
    end

    # Convenience methods. They provide a slighly terser external API to instantiate contracts.
    def self.at(*contracts);       self.new.at(*contracts);       end

    def self.of(*contracts);       self.new.of(*contracts);       end

    def self.with(*contracts);     self.new.with(*contracts);     end

    def self.every(*contracts);    self.new.every(*contracts);    end

    def self.instance(*contracts); self.new.instance(*contracts); end

    def self.meta(opts);           self.new.meta(opts);           end

    def self.size(size);           self.new.size(size);           end

    # contract Array.of(Contract).size(1)
    def of(contract)
      every(contract)
    end

    # contract Hash.of(And[Integer, Gt[0]] => Contract)
    def at(contracts)
      contracts.each do |index, contract|
        if !index.is_a?(::Integer) || index < 0
          raise 'Invalid contract usage: Array.at keys must be valid array indices (callable).'
        end
        if !contract.respond_to?(:call)
          raise 'Invalid contract usage: Array.at values must be contracts (callable).'
        end

        add_contract ArrayHelper.get_index_contract(contract: contract, index: index)
      end

      self
    end

    # Position matters on this one
    # contract Array.of(Contract)
    def with(contracts)
      at(contracts.map.with_index { |val, idx| [idx, val] }.to_h)
    end

    # contract And[Integer, ->(x) { x > 0 }]
    def size(size)
      instance(->(i) { i.size == size })
    end

    # contract Array.of(Contract).size(1)
    def every(contract)
      if !contract.respond_to?(:call)
        raise 'Invalid contract usage: Array.every only accepts contracts (callable).'
      end

      add_contract ArrayHelper.get_every_value_contract(contract: contract)

      self
    end

    # contract Or[Contract, Array.of(Contract)]
    def instance(contracts)
      [contracts]
        .flatten
        .each do |contract|
          if !contract.respond_to?(:call)
            raise 'Invalid contract usage: Array.instance values must be contracts (callable).'
          end

          add_contract ArrayHelper.get_instance_contract(contract: contract)
        end

      self
    end

  end

end
