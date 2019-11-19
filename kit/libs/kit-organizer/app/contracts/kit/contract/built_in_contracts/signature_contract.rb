module Kit::Contract::BuiltInContracts

  SignatureContract = Or[Callable, Hash.of(Callable => ResultTupple).size(1)]

end