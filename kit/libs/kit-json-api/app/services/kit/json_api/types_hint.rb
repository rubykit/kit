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
      Kit::JsonApi::TypesHint::Date      => [:eq, :gt, :gte, :le, :lte],
      Kit::JsonApi::TypesHint::Id        => [:eq],
      Kit::JsonApi::TypesHint::IdString  => [:eq],
      Kit::JsonApi::TypesHint::IdNumeric => [:eq],
      Kit::JsonApi::TypesHint::Numeric   => [:eq, :gt, :gte, :le, :lte],
      Kit::JsonApi::TypesHint::String    => [:eq, :contain, :start_with, :end_with],
    }
  end

end