class Kit::Auth::Admin::Attributes::Application < Kit::Admin::Attributes

  def self.all
    base_attributes.merge(
      name:         :code,
      created_at:   nil,
      updated_at:   nil,
      uid:          :code,
      scopes:       :code,
      confidential: nil,
    )
  end

end
