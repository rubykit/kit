class Kit::Auth::Admin::Attributes::UserOauthIdentity < Kit::Admin::Attributes

  def self.all
    base_attributes.merge(
      user:         :model_verbose,

      provider:     :color,
      provider_uid: :code,

      data:         :pre_yaml,
    )
  end

  def self.index
    all.except(:data)
  end

end
