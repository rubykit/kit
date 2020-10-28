# Uniqueness constraint as a Contract.
class Kit::Store::Contracts::Unique < Kit::Contract::Types::InstantiableContract

  def initialize(*index_contracts) # rubocop:disable Lint/MissingSuper
    @contracts_list = []

    instance(IsA[::Array])
    with(index_contracts || [])
  end

  def call(args)
    ArrayHelper.run_contracts(list: @contracts_list, args: [args])
  end

end
