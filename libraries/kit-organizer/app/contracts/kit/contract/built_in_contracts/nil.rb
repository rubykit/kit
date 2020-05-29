# Ensure that the argument equals the saved Contract value

module Kit::Contract::BuiltInContracts

  Nil    = Eq[nil].named('Nil')
  NonNil = NotEq[nil].named('NonNil')

end
