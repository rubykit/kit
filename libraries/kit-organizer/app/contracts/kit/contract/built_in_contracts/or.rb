module Kit::Contract::BuiltInContracts

  class Or < InstanciableType
    def initialize(*contracts)
      @contracts = contracts
    end

    def call(*args)
      results = @contracts.map do |contract|
        Kit::Contract::Services::Validation.valid?(contract: contract, args: args)
      end

      failed = results.select { |status, _| status == :error }

      if failed.size != @contracts.size
        [:ok]
      else
        errors = [{detail: 'OR failed'},]
        failed.each do |status, ctx|
          errors += ctx[:errors]
        end

        [:error, {
          errors:         errors,
          contract_error: failed[0][1][:contract_error],
        }]
      end
    end
  end

end