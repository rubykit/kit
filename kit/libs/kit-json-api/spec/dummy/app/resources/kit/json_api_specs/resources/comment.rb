module Kit::JsonApi::Spec::Resources::Comment

  def self.fields
    {
      id:         nil,
      created_at: nil,
      text:       nil,
    }
  end

  def self.filters
    {
      id:         [:eq, :gt, :gte, :le, :lte],
      email:      [:eq, :contains, :start_with, :end_with],
      created_at: [:eq, :gt, :gte, :le, :lte],
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
      post: {
        resource: Kit::JsonApi::Tests::Resources::Post,
        inclusion: {
          top_level: true,
          nested:    false,
        },
      },
      owner: {
        resource: Kit::JsonApi::Tests::Resources::User,
        inclusion: {
          top_level: true,
          nested:    true,
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