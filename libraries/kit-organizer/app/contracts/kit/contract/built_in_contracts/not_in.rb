=begin
# Acts as an enum
# And[NotEq[:ok], NotEq[:error]] == NotIn[:ok, :error]
# Handle ranges too
class Kit::Contract::BuiltInContracts::NotIn < Kit::Contract::BuiltInContracts::InstanciableType

end
=end