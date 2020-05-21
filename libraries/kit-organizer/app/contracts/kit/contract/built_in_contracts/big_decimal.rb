require 'bigdecimal'

module Kit::Contract::BuiltInContracts

  # Ensure that the argument is a `::BigDecimal`.
  BigDecimal = IsA[::BigDecimal]

end
