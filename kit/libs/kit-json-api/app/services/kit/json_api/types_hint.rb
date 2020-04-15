# Define defaults operators available per type.
module Kit::JsonApi::TypesHint

  Boolean   = :boolean
  Date      = :date
  Id        = :id
  IdString  = :id_string
  IdNumeric = :id_numeric
  Numeric   = :numeric
  String    = :string

  def self.defaults
    {
      Kit::JsonApi::TypesHint::Boolean   => [:eq],
      Kit::JsonApi::TypesHint::Date      => [:eq, :in, :gt, :gte, :lt, :lte],
      Kit::JsonApi::TypesHint::Id        => [:eq, :in],
      Kit::JsonApi::TypesHint::IdString  => [:eq, :in],
      Kit::JsonApi::TypesHint::IdNumeric => [:eq, :in],
      Kit::JsonApi::TypesHint::Numeric   => [:eq, :in, :gt, :gte, :lt, :lte],
      Kit::JsonApi::TypesHint::String    => [:eq, :in, :contain, :start_with, :end_with],
    }
  end

end
