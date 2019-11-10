module Kit::Contract::Types

  Status = In[:ok, :error]
  ResultTupple = Or[Tupple[Status], Tupple[Status, Kit::Contract::Types::Hash]]

end