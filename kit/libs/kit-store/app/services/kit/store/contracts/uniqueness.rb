  class Kit::Store::Contracts::Unique < Kit::Contract::Types::InstanciableType

    def initialize(*index_contracts)
      @contracts_list = []

      instance(IsA[::Array])
      with(index_contracts || [])
    end

    def call(args)
      ArrayHelper.run_contracts(list: @contracts_list, args: [args])
    end