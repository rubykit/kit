module Kit::Contract::BuiltInContracts

  # Ensure that the argument is an `::Integer`.
  Integer = IsA[::Integer]
  Int     = Integer

  # Ensure that the Contract argument is a positive `::Integer`.
  PositiveInteger = And[Integer, ->(size) { size > 0 }]
  PosInt          = PositiveInteger

  # Ensure that the Contract argument is a negative `::Integer`.
  NegativeInteger = And[Integer, ->(size) { size < 0 }]
  NegInt          = NegativeInteger

end
