class Kit::Admin::Attributes

  def self.all
    raise "IMPLEMENT ME"
  end

  def self.index
    all
  end

  # Dummy default implementation
  def self.list
    index
  end

  def self.show
    all
  end

  def self.base_attributes
    {
      id:             :model_id,
      created_at:     nil,
      updated_at:     nil,
    }
  end

end
