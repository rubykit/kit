# Contracts for the project
module Kit::Organizer::Contracts

  include Kit::Contract::BuiltInContracts

  SuccessStatus = Eq[:ok]
  ErrorStatus   = Eq[:error]
  Status        = Or[SuccessStatus, ErrorStatus]

  # TODO: provide smarter `SuccessResultTupple` to express expected ctx values
  SuccessResultTupple = Or[
    Tupple[SuccessStatus],
    Tupple[SuccessStatus, Hash],
  ]

  ErrorResultTupple = Or[
    Tupple[ErrorStatus],
    Tupple[ErrorStatus, Hash],
  ]

  # Accepts laxer Error formats that will need to be sanitized
  TmpErrorResultTupple = Or[
    ErrorResultTupple,
    Tupple[ErrorStatus, String],
    Tupple[ErrorStatus, Array],
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
