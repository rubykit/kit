module Kit::Contract::Types

  # Ex: Array[ContractArg0, ContractArg1].remaining(ContractOnRemainingArgs).each(ContractOnAll).instance(ContractOnTheInstance)
  #  .size(2) would be a specific instance contract

=begin
  Contract types:
    default:  applies to the element at index X
    all:      applies to all elements
    instance: applies to the array itself

    size:     specific instance contract
=end

  module Array < InstanciableType
  end

end