module Kit::Organizer::Contracts

  Status = In[:ok, :error]

  SuccessResultTupple = Or[
    Tupple[Eq[:ok]],
    Tupple[Eq[:ok], Kit::Contract::BuiltInContracts::Hash],
  ]

  ErrorResultTupple = Or[
    Tupple[Eq[:error]],
    Tupple[Eq[:error], Kit::Contract::BuiltInContracts::Hash],
  ]

  # Accepts laxer Error formats that will need to be sanitized
  TmpErrorResultTupple = Or[
    ErrorResultTupple,
    Tupple[Eq[:error], Kit::Contract::BuiltInContracts::String],
    Tupple[Eq[:error], Kit::Contract::BuiltInContracts::Array],
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