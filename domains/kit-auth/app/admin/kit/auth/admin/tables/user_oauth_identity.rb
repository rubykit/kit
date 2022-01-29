class Kit::Auth::Admin::Tables::UserOauthIdentity < Kit::ActiveAdmin::Table

  def self.attributes_for_all
    base_attributes.merge(
      user:         :model_verbose,

      provider:     :color_tag,
      provider_uid: :code,

      data:         :pre_yaml,
    )
  end

end
