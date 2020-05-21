# This module contains some Built-in Contracts
# The easiest way to use them is to include `Kit::Contract::BuiltInContracts` in your class/module.
#
# * Basic types
#   * `Any`: succeeds for any argument.
#   * `Array`: ensure that the argument is an `::Array`. Index based constraints can also be expressed. See Array doc.
#   * `Args`: variation of Array that lets you define contract for positional arguments.
#   * `BigDecimal`: ensure that the argument is a `::BigDecimal`.
#   * `Boolean`: ensure that the argument is `true` or `false`.
#   * `Complex`: ensure that the argument is a `::Complex`.
#   * `FalseClass`: ensure that the argument is a `::FalseClass`.
#   * `Float`: ensure that the argument is a `::Float`.
#   * `Hash`: ensure that the argument is a `::Hash`. Key based constraints can also be expressed. See Hash doc.
#   * `Integer`: ensure that the argument is a `::Integer`.
#   * `Numeric`: ensure that the argument is a `::Numeric`.
#   * `Rational`: ensure that the argument is a `::Rational`.
#   * `String`: ensure that the argument is a `::String`.
#   * `Symbol`: ensure that the argument is a `::Symbol`.
#   * `TrueClass`: ensure that the argument is a `::TrueClass`.
#   * `Tupple`: variation of `Array` with an implicit check on size.
# * Operations
#   * `And`: ensure all contracts are successful
#   * `Optional`: ensure that if there is a value, it it not nil
#   * `Or`: ensure at least one contract is successful
# * Dependent types
#   * `Callable`: alias of `RespondTo[:call]`
#   * `Enum`: alias of `In`
#   * `Eq`: ensure that the argument equals the given value
#   * `In`: ensure the argument is part of a given collection of objects / values
#   * `NotEq`: ensure that the argument does not equal the given value
#   * `NotIn`: ensure that the argument is not part of a given collection of objects / values
#   * `RespondTo`: ensure that the object `respond_to?` a specific method
module Kit::Contract::BuiltInContracts
end
