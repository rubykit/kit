module Kit::Organizer::Contracts
  include Kit::Contract::BuiltInContracts

  SuccessStatus = Eq[:ok]
  ErrorStatus   = Eq[:error]
  Status        = Or[SuccessStatus, ErrorStatus]

  # TODO: provide smarter `SuccessResultTupple` to express expected ctx values
  SuccessResultTupple = Or[
    Tupple[Eq[:ok]],
    Tupple[Eq[:ok], Hash],
  ]

  ErrorResultTupple = Or[
    Tupple[Eq[:error]],
    Tupple[Eq[:error], Hash],
  ]

  # Accepts laxer Error formats that will need to be sanitized
  TmpErrorResultTupple = Or[
    ErrorResultTupple,
    Tupple[Eq[:error], String],
    Tupple[Eq[:error], Array],
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