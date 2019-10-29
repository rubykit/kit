module Kit::Contract::Types

  # Less permissive version of Array. On a Tupple the size is implicit.
  class Tupple < Array

    def initialize(index_contracts)
      @contracts_list = []

      instance(IsA[::Array])
      with(index_contracts)
      size(index_contracts.size)
    end

  end

end