module Kit::Auth::Admin::UserOauthIdentity
end

ActiveAdmin.register Kit::Auth::Models::Read::UserOauthIdentity, as: 'UserOauthIdentity', namespace: :kit_auth do
  menu label: 'UserOAuthIdentity', parent: 'Users'

  actions :all, except: [:new, :edit, :destroy]

  index do
    Kit::Auth::Admin::Tables::UserOauthIdentity.new(self).index
  end

  show do

    columns do
      column do
        Kit::Auth::Admin::Tables::UserOauthIdentity.new(self).panel(resource,
          attrs_except: [:provider, :provider_uid, :data],
        )
      end

      column do
        Kit::Auth::Admin::Tables::UserOauthIdentity.new(self).panel(resource,
          title:      'Provider data',
          attrs_only: [:provider, :provider_uid, :data],
        )
      end
    end

    hr

    Kit::Auth::Admin::Tables::UserOauthSecret.new(self).panel_list(resource.user_oauth_secrets,
      title:        'UserOauthSecrets',
      attrs_list:   :all,
      attrs_except: [:user_oauth_identity],
    )
  end

end
