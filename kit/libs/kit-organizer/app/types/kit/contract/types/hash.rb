module Kit::Contract::Types

=begin
  Contract types:
    all:      applies to all [key, value]
    instance: applies to the hash itself
    keys:     applies to all keys
    targeted: applies to specific `key: value` (this is the default when defining contracts)
    values:   applies to all values

    size:     specific instance contract
=end

  class Hash < InstanciableType
    def initialize(targeted_contracts)
      @contracts = {
        all:      { callable: self.class.method(:enforce_all_contracts),      list: [], }
        instance: { callable: self.class.method(:enforce_instance_contracts), list: [IsA[::Hash]], },
        keys:     { callable: self.class.method(:enforce_keys_contracts),     list: [], },
        targeted: { callable: self.class.method(:enforce_targeted_contracts), list: targeted_contracts, },
        values:   { callable: self.class.method(:enforce_values_contracts),   list: [], },
      }
    end

    def all(contracts);      @contracts[:all][:list].concat!(contracts); end
    def instance(contracts); @contracts[:instance][:list].concat!(contracts); end
    def keys(contracts);     @contracts[:keys][:list].concat!(contracts); end
    def targeted(contracts); @contracts[:targeted][:list].concat!(contracts); end
    def values(contracts);   @contracts[:values][:list].concat!(contracts); end

    def call(**args)
      order = [:instance, :targeted, :keys, :values, :all]

      status = :ok
      ctx    = {}

      list.each do |contract_type|
        data           = @contracts[contract_type]
        callable       = data[:callable]
        contracts_list = data[:list]

        local_status, local_ctx = callable.call({ args: args, contracts_list: contracts_list, })

        if result == :error
          status = :error
          ctx[:errors] = local_ctx[:errors]
          break
        end
      end

      [status, ctx]
    end

    def self.enforce_instance_contracts(args:, contracts_list:)
      # HOW DO WE DO THIS ?!
    end

    def self.enforce_targeted_contracts(args:, contracts_list:)
      return [:ok] if contracts_list.size == 0

      expected_keys = contracts_list.keys
      missing_keys  = expected_keys - args.keys
      return [:error, "Missing keys `#{missing_keys}`"] if missing_keys.size > 0

      global_status = :ok
      errors        = []
      contracts_list.each do |key_name, contract|
        status, ctx = Kit::Contract::Services::Types.valid?(contract: contract, args: args[key_name])

        if status == :error
          global_status = :error
          if ctx[:errors]
            errors = errors.concat(ctx[:errors])
          end
        end
      end

      result = [global_status]
      if errors.size > 0
        result[1] = { errors: errors }
      end

      result
    end

    def self.enforce_default_contracts(**args)
    end

  end

end