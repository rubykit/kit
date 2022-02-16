class Kit::Auth::Admin::Attributes::UserSecret < Kit::Admin::Attributes

  def self.all
    base_attributes.merge(
      created_at:  nil,
      updated_at:  nil,
      user:        :model_verbose,
      application: :model_verbose,
      secret:      :code,
      active:      [nil, ->(el) { el.active? }],
      expires_in:  :code,
      scopes:      :code,
      revoked_at:  nil,
    )
  end

  def self.index
    all.slice(:id, :created_at, :user, :active, :scopes, :application, :expires_in, :revoked_at)
  end

end
