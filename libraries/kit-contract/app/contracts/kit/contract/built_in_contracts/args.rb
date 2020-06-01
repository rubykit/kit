module Kit::Contract::BuiltInContracts

  # Allows to treat callable arguments as an array
  class Args < Kit::Contract::BuiltInContracts::Array

    # Receives the list of arguments as an array, and forwards it the first argument.
    def call(*args)
      super(args)
    end

  end

end
