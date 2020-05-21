# Less permissive version of Array. On a Tupple the size is implicit.
class Kit::Contract::BuiltInContracts::Tupple < Kit::Contract::BuiltInContracts::Array

  def setup(*index_contracts)
    super
    size(index_contracts.size)
  end

end
