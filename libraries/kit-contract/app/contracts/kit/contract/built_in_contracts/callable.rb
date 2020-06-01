module Kit::Contract::BuiltInContracts

  # Ensure the argument respond_to(:call)
  Callable  = RespondTo[:call]

  # Ensure the argument is an Array of Callable
  Callables = Array.of(Callable)

end
