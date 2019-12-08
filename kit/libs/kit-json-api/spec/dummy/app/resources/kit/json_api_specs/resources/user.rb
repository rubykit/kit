module Kit::JsonApi::Spec::Resources::User

  def self.fields
    {
      id:         nil,
      created_at: nil,
      email:      nil,
    }
  end

  def self.filters
    {
      id:         [:eq, :gt, :gte, :le, :lte],
      created_at: [:eq, :gt, :gte, :le, :lte],
      email:      [:eq, :contains, :start_with, :end_with],
    }
  end

  def self.sort
    {
      id:         [:asc, :desc],
      created_at: [:asc, :desc],
    }
  end

  def self.relationships
    {
      posts: {
        type:     :has_many,
        resource: Kit::JsonApi::Tests::Resources::Post,
        defaults: {
          sort:  [[:created_at, :desc], [:id, :desc]],
          limit: 3,
        },
        inclusion: {
          top_level: true,
          nested:    false,
        },
      },
      comments: {
        type:     :has_many,
        resource: Kit::JsonApi::Tests::Resources::Comment,
        inclusion: {
          top_level: false,
          nested:    false,
        },
      },
    }
  end

  def self.load_data(**)
  end

  def self.single_link(**)
  end

  def self.link_list(**)
  end

end