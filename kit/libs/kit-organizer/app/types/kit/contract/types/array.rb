module Kit::Contract::Types

=begin
  Contract types:
    of:          alias of `every_value`, for types
    with:        run on the value of specific indeces (this is the default when using Hash[data])
    at:          here ordering matters

    every:       run on every value
    instance:    run on the hash instance itself

    size:        instance contract about size
=end

=begin
  Internal types of behaviour:
    every_value: run on every value
    index:       run on value at index N
    instance:    run on the hash instance itself
=end

  module ArrayHelper

    def self.run_contracts(list:, args:)
      list.each do |contract|
        status, _ = result = contract.call(*args)
        return result if status == :error
      end

      [:ok]
    end

    def self.get_index_contract(contract:, index:)
      ->(instance) do
        Kit::Contract::Services::Validation.valid?(contract: contract, args: [instance[index]])
      end
    end

    def self.get_instance_contract(contract:)
      ->(instance) do
        Kit::Contract::Services::Validation.valid?(contract: contract, args: [instance])
      end
    end

    def self.get_every_value_contract(contract:)
      ->(instance) do
        instance.each do |value|
          result = status, ctx = Kit::Contract::Services::Validation.valid?(contract: contract, args: [value])
          return result if status == :error
        end
        [:ok]
      end
    end
  end

  class Array < InstanciableType

    def initialize(index_contracts = nil)
      @contracts_list = []

      instance(IsA[::Array])
      with(index_contracts || [])
    end

    def call(*args)
      ArrayHelper.run_contracts(list: @contracts_list, args: args)
    end

    def add_contract(contract)
      @contracts_list << contract
    end

    # NOTE: this will only be useful when Organizer can handle any signature
    def to_contracts
      @contracts_list
    end

    # Convenience methods. They provide a slighly terser external API.
    def self.at(contracts);    self.new.at(contracts);    end;
    def self.of(contracts);    self.new.of(contracts);    end;
    def self.with(contracts);  self.new.with(contracts);  end;
    def self.every(contracts); self.new.every(contracts); end;
    def self.instance(size);   self.new.instance(size);   end;
    def self.size(size);       self.new.size(size);       end;


    # contract Array.of(Contract).size(1)
    def of(contract)
      every(contract)
    end

    # contract Hash.of(And[Integer, Gt[0]] => Contract)
    def at(contracts)
      contracts.each do |index, contract|
        if index.is_a?(Integer) || index < 0
          raise "Invalid contract usage: Hash.at keys must be valid array indices (callable)"
        end
        if !contract.respond_to?(:call)
          raise "Invalid contract usage: Hash.at values must be contracts (callable)"
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
        raise "Invalid contract usage: Array.every only accepts contracts (callable)"
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
            raise "Invalid contract usage: Array.instance values must be contracts (callable)"
          end

          add_contract ArrayHelper.get_instance_contract(contract: contract)
        end

      self
    end

  end

end