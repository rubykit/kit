require_relative 'base_table'

class Kit::Auth::Admin::Tables::UserSecret < Kit::Auth::Admin::Tables::BaseTable

  def attributes_for_all
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

  def attributes_for_index
    attributes_for_all.slice(:id, :created_at, :user, :active, :scopes, :application, :expires_in, :revoked_at)
  end

  def attributes_for_list
    attributes_for_index
  end

  def attributes_for_show
    attributes_for_all
  end

end
