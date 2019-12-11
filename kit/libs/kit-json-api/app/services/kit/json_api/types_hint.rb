module Kit::JsonApi::TypesHint

  def self.defaults_filters
    {
      JsonApi::TypeHints::boolean    => [:eq],
      JsonApi::TypeHints::id         => [:eq],
      JsonApi::TypeHints::id_string  => [:eq],
      JsonApi::TypeHints::id_numeric => [:eq],
      JsonApi::TypeHints::date       => [:eq, :gt, :gte, :le, :lte],
      JsonApi::TypeHints::numeric    => [:eq, :contain, :start_with, :end_with],
      JsonApi::TypeHints::date       => [:eq, :gt, :gte, :le, :lte],
    }
  end

end