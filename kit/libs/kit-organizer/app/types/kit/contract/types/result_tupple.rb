module Kit::Contract::Types

  Status = In[:ok, :error]

  ResultTupple = Or[
    Tupple[Status],
    Tupple[Status, Or[
      Kit::Contract::Types::Hash,
      Kit::Contract::Types::String,
      Kit::Contract::Types::Array,
    ]],
  ]

end