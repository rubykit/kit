module Kit::JsonApiSpec::Resources::Post

  def self.fields
    {
      id:         nil,
      created_at: nil,
      url:        nil,
    }
  end

  def self.filters
    {
      id:         [:eq, :gt, :gte, :le, :lte],
      created_at: [:eq, :gt, :gte, :le, :lte],
      url:        [:eq, :contains],
      owner_id:   [:eq],
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
      owner: {
        type:     :has_one,
        resource: Kit::JsonApi::Tests::Resources::User,
        inclusion: {
          top_level: true,
          nested:    true,
        },
      },
      comments: {
        type:     :has_many,
        resource: Kit::JsonApi::Tests::Resources::Comment,
        defaults: {
          sort:  [[:created_at, :desc], [:id, :desc]],
          limit: 5,
        },
        inclusion: {
          top_level: true,
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