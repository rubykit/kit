class Kit::Domain::Admin::Tables::Event < Kit::ActiveAdmin::Table

  def self.attributes_for_all
    {
      id:         nil,
      created_at: nil,

      name:       :code,
      data:       :pre_yaml,
      metadata:   :pre_yaml,
    }
  end

end
