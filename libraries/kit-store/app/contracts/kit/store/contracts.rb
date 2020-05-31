# Contracts for the project.
module Kit::Store::Contracts

  include Kit::Contract::BuiltInContracts

  Store        = IsA[Kit::Store::Types::Store]

  TableName    = Symbol
  Table        = IsA[Kit::Store::Types::Table]

  ColumnName   = Symbol
  ColumnNames  = Array.of(ColumnName)

  InnerRecord  = IsA[Kit::Store::Types::InnerRecord]
  InnerRecords = Array.of(InnerRecord)

  Record       = IsA[Kit::Store::Types::Record]
  Records      = Array.of(Record)

  Ordering     = In[:asc, :desc]
  Order        = Tupple[ColumnName, Ordering]

  Orders       = Array.of(Order)

end
