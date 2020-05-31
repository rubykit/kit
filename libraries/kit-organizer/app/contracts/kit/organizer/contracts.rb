# Contracts for the project.
module Kit::Organizer::Contracts

  include Kit::Contract::BuiltInContracts

  SuccessStatus = Eq[:ok]
  ErrorStatus   = Eq[:error]
  Status        = Or[SuccessStatus, ErrorStatus].named('Status')

  # TODO: provide smarter `SuccessResultTupple` to express expected ctx values
  SuccessResultTupple = Or[
    Tupple[SuccessStatus],
    Tupple[SuccessStatus, Hash],
  ].named('SuccessResultTupple')

  ErrorResultTupple = Or[
    Tupple[ErrorStatus],
    Tupple[ErrorStatus, Hash],
  ].named('ErrorResultTupple')

  # Accepts laxer Error formats that will need to be sanitized
  TmpErrorResultTupple = Or[
    ErrorResultTupple,
    Tupple[ErrorStatus, String],
    Tupple[ErrorStatus, Array],
  ].named('TmpErrorResultTupple')

  ResultTupple = Or[
    SuccessResultTupple,
    ErrorResultTupple,
  ].named('ResultTupple')

  TmpResultTupple = Or[
    ResultTupple,
    TmpErrorResultTupple,
  ].named('TmpResultTupple')

end
