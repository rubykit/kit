module Kit::Contract::BuiltInContracts

  # Acts as an enum
  # And[NotEq[:ok], NotEq[:error]] == NotIn[:ok, :error]
  # Handle ranges too
  class In < InstanciableType
  end

end