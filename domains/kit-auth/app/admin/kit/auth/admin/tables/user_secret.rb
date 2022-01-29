class Kit::Auth::Admin::Tables::UserSecret < Kit::ActiveAdmin::Table

  def self.attributes_for_all
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

  def self.attributes_for_index
    attributes_for_all.slice(:id, :created_at, :user, :active, :scopes, :application, :expires_in, :revoked_at)
  end

end
