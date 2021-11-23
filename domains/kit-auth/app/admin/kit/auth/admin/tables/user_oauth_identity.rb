require_relative 'base_table'

class Kit::Auth::Admin::Tables::UserOauthIdentity < Kit::Auth::Admin::Tables::BaseTable

  def attributes_for_all
    base_attributes.merge(
      user:         :model_verbose,

      provider:     :color_tag,
      provider_uid: :code,

      data:         :pre_yaml,
    )
  end

  def attributes_for_index
    attributes_for_all
  end

  def attributes_for_list
    attributes_for_index
  end

  def attributes_for_show
    attributes_for_all
  end

end
