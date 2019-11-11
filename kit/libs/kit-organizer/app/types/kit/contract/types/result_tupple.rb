module Kit::Contract::Types

  Status = In[:ok, :error]

  ResultTupple = Or[
    Tupple[Eq[:ok]],
    Tupple[Eq[:ok], Kit::Contract::Types::Hash],
    Tupple[Eq[:error]],
    Tupple[Eq[:error], Kit::Contract::Types::Hash],
  ]

  TmpResultTupple = Or[
    ResultTupple,
    Tupple[Eq[:error], Kit::Contract::Types::String],
    Tupple[Eq[:error], Kit::Contract::Types::Array],
  ]

end