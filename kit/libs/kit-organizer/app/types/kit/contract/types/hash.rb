module Kit::Contract::Types

=begin
  Contract types:
    all:      run on all [key, value]
    instance: run on the hash instance itself
    keys:     run on all keys
    targeted: run on the value of specific key (this is the default when defining contracts)
    values:   run on all values

    size:     specific instance contract
=end

  class Hash < InstanciableType
    def initialize(targeted_contracts = nil)
      targeted_contracts ||= []

      @contracts = {
        all:      { callable: self.class.method(:enforce_all_contracts),      list: [], },
        instance: { callable: self.class.method(:enforce_instance_contracts), list: [IsA[::Hash]], },
        keys:     { callable: self.class.method(:enforce_keys_contracts),     list: [], },
        targeted: { callable: self.class.method(:enforce_targeted_contracts), list: targeted_contracts, },
        values:   { callable: self.class.method(:enforce_values_contracts),   list: [], },
      }
    end

    def all(contracts)
      @contracts[:all][:list].send((contracts.is_a?(::Array) ? :concat : :push), contracts)
      self
    end

    def instance(contracts)
      @contracts[:instance][:list].send((contracts.is_a?(::Array) ? :concat : :push), contracts)
      self
    end

    def keys(contracts)
      @contracts[:keys][:list].send((contracts.is_a?(::Array) ? :concat : :push), contracts)
      self
    end

    def targeted(contracts)
      @contracts[:targeted][:list].send((contracts.is_a?(::Array) ? :concat : :push), contracts)
      self
    end

    def values(contracts)
      @contracts[:values][:list].send((contracts.is_a?(::Array) ? :concat : :push), contracts)
      self
    end

    def call(**args)
      order = [:instance, :targeted, :keys, :values, :all]

      status = :ok
      ctx    = {}

      order.each do |contract_type|
        data           = @contracts[contract_type]
        callable       = data[:callable]
        contracts_list = data[:list]

        local_status, local_ctx = callable.call({ args: args, contracts_list: contracts_list })

        if local_status == :error
          status       = :error
          ctx[:errors] = local_ctx&.dig(:errors)
          break
        end
      end

      [status, ctx]
    end

    def self.enforce_all_contracts(args:, contracts_list:)
      return [:ok] if contracts_list.size == 0

      list = args.map do |key, value|
        contracts_list.map do |contract|
          { contract: contract, args: [key, value], }
        end
      end.flatten(1)

      Kit::Contract::Services::Types.all_valid?(list: list)
    end

    def self.enforce_instance_contracts(args:, contracts_list:)
      return [:ok] if contracts_list.size == 0

      list = contracts_list.map do |contract|
        { contract: contract, args: args, }
      end

      Kit::Contract::Services::Types.all_valid?(list: list)
    end

    def self.enforce_keys_contracts(args:, contracts_list:)
      return [:ok] if contracts_list.size == 0

      list = args.map do |key, value|
        contracts_list.map do |contract|
          { contract: contract, args: key, }
        end
      end.flatten(1)

      Kit::Contract::Services::Types.all_valid?(list: list)
    end

    def self.enforce_targeted_contracts(args:, contracts_list:)
      return [:ok] if contracts_list.size == 0

      expected_keys = contracts_list.keys
      missing_keys  = expected_keys - args.keys
      return [:error, "Missing keys `#{missing_keys}`"] if missing_keys.size > 0

      list = contracts_list.map do |key_name, contract|
        { contract: contract, args: args[key_name], }
      end

      Kit::Contract::Services::Types.all_valid?(list: list)
    end

    def self.enforce_values_contracts(args:, contracts_list:)
      return [:ok] if contracts_list.size == 0

      list = args.map do |key, value|
        contracts_list.map do |contract|
          { contract: contract, args: value, }
        end
      end.flatten(1)

      Kit::Contract::Services::Types.all_valid?(list: list)
    end

  end

end