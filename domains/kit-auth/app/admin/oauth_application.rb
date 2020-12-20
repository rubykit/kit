Kit::Auth::Admin.register Kit::Auth::Models::Read::OauthApplication, as: 'OauthApplication', namespace: :kit_auth_admin do
  menu label: 'OAuthApplication', parent: 'OAuth'

  actions :all, except: [:new, :edit, :destroy]

  index do
    Kit::Auth::Admin::Tables::OauthApplication.new(self).index
  end

  show do
    Kit::Auth::Admin::Tables::OauthApplication.new(self).panel resource

    hr

    columns do
      column do
        Kit::Auth::Admin::Tables::OauthAccessGrant.new(self).panel_list resource.oauth_access_grants
      end

      column do
        Kit::Auth::Admin::Tables::OauthAccessToken.new(self).panel_list resource.oauth_access_tokens
      end
    end
  end

end
