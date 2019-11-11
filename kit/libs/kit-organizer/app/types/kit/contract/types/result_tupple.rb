module Kit::Contract::Types

  Status = In[:ok, :error]

  SuccessResultTupple = Or[
    Tupple[Eq[:ok]],
    Tupple[Eq[:ok], Kit::Contract::Types::Hash],
  ]

  ErrorResultTupple = Or[
    Tupple[Eq[:error]],
    Tupple[Eq[:error], Kit::Contract::Types::Hash],
  ]

  # Accepts laxer Error formats that will need to be sanitized
  TmpErrorResultTupple = Or[
    ErrorResultTupple,
    Tupple[Eq[:error], Kit::Contract::Types::String],
    Tupple[Eq[:error], Kit::Contract::Types::Array],
  ]

  ResultTupple = Or[
    SuccessResultTupple,
    ErrorResultTupple,
  ]

  TmpResultTupple = Or[
    ResultTupple,
    TmpErrorResultTupple,
  ]

end