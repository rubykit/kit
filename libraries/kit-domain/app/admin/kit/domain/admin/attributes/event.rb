class Kit::Domain::Admin::Attributes::Event < Kit::Admin::Attributes

  def self.all
    {
      id:         nil,
      created_at: nil,
      emitted_at: nil,

      name:       :code,
      data:       :pre_yaml,
      metadata:   :pre_yaml,
    }
  end

end
