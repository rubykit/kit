module Kit::Contract::Types

  # Acts as an enum
  # Or[Eq[:ok], Eq[:error]] == In[:ok, :error]
  # Handle ranges too
  class In < InstanciableType
  end

end