module Kit::Contract::BuiltInContracts

  # Ensure that the argument is `true` or `false`.
  Boolean = Or[IsA[::TrueClass], IsA[::FalseClass]]

end
