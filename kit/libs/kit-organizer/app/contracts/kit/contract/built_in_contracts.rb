# This module contains some Built-in Contracts
# The easiest way to use them is to include `Kit::Contract::BuiltInContracts` in your class/module.
#
# * Basic types
#   * `Any`: succeeds for any argument.
#   * `Array`: ensures that the argument is an `::Array`. Index based constraints can also be expressed. See Array doc.
#   * `Args`: variation of Array that lets you define contract for positional arguments.
#   * `BigDecimal`: ensures that the argument is a `::BigDecimal`.
#   * `Boolean`: ensures that the argument is `true` or `false`.
#   * `Complex`: ensures that the argument is a `::Complex`.
#   * `FalseClass`: ensures that the argument is a `::FalseClass`.
#   * `Float`: ensures that the argument is a `::Float`.
#   * `Hash`: ensures that the argument is a `::Hash`. Key based constraints can also be expressed. See Hash doc.
#   * `Integer`: ensures that the argument is a `::Integer`.
#   * `Numeric`: ensures that the argument is a `::Numeric`.
#   * `Rational`: ensures that the argument is a `::Rational`.
#   * `String`: ensures that the argument is a `::String`.
#   * `Symbol`: ensures that the argument is a `::Symbol`.
#   * `TrueClass`: ensures that the argument is a `::TrueClass`.
#   * `Tupple`: variation of `Array` with an implicit check on size.
# * Operations
#   * `And`: ensures all contracts are successful
#   * `Optional`: ensures that if there is a value, it it not nil
#   * `Or`: ensures at least one contract is successful
# * Dependent types
#   * `Callable`: alias of `RespondTo[:call]`
#   * `Enum`: alias of `In`
#   * `Eq`: ensures that the argument equals the given value
#   * `In`: ensures the argument is part of a given collection of objects / values
#   * `NotEq`: ensures that the argument does not equal the given value
#   * `NotIn`: ensures that the argument is not part of a given collection of objects / values
#   * `RespondTo`: ensures that the object `respond_to?` a specific method
module Kit::Contract::BuiltInContracts
end