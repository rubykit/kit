# Define defaults operators available per type.
module Kit::Api::JsonApi::TypesHint

  Boolean   = :boolean
  Date      = :date
  Id        = :id
  IdString  = :id_string
  IdNumeric = :id_numeric
  Numeric   = :numeric
  String    = :string

  def self.defaults
    {
      Kit::Api::JsonApi::TypesHint::Boolean   => [:eq],
      Kit::Api::JsonApi::TypesHint::Date      => [:eq, :in, :gt, :gte, :lt, :lte],
      Kit::Api::JsonApi::TypesHint::Id        => [:eq, :in],
      Kit::Api::JsonApi::TypesHint::IdString  => [:eq, :in],
      Kit::Api::JsonApi::TypesHint::IdNumeric => [:eq, :in],
      Kit::Api::JsonApi::TypesHint::Numeric   => [:eq, :in, :gt, :gte, :lt, :lte],
      Kit::Api::JsonApi::TypesHint::String    => [:eq, :in, :contain, :start_with, :end_with],
    }
  end

end
