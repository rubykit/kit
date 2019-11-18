module Kit::Contract::Types

  # Allows to treat callable arguments as an array
  class Args < Kit::Contract::Types::Array

    # Receives the list of arguments as an array, and forwards it the first argument.
    def call(*args)
      ArrayHelper.run_contracts(list: @contracts_list, args: [args])
    end

  end

end