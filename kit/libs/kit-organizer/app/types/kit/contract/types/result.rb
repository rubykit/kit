module Kit::Contract::Types

  Status = In[:ok, :error]
  Result = Or[Tupple[Status], Tupple[Status, Hash]]

end