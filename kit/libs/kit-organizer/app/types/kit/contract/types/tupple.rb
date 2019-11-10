module Kit::Contract::Types

  # Less permissive version of Array. On a Tupple the size is implicit.
  class Tupple < Kit::Contract::Types::Array

    def initialize(*index_contracts)
      super
      size(index_contracts.size)
    end

  end

end