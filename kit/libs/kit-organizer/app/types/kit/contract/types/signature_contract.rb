module Kit::Contract::Types

  SignatureContract = Or[Callable, Hash.of(Callable => ResultTupple).size(1)]

end