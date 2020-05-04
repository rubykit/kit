::ActiveAdmin.register Kit::Auth::Models::Read::OauthAccessToken, as: 'OauthAccessToken', namespace: :kit_auth_admin do
  menu label: 'OAuthAccessToken', parent: 'OAuth'

  actions :all, except: [:new, :edit, :destroy]

  index do
    Kit::Auth::Admin::Tables::OauthAccessToken.new(self).index
  end

  show do
    Kit::Auth::Admin::Tables::OauthAccessToken.new(self).panel resource

    hr

    columns do
      column do
        Kit::Auth::Admin::Tables::User.new(self).panel resource.resource_owner
      end

      column do
        Kit::Auth::Admin::Tables::OauthApplication.new(self).panel resource.oauth_application
      end
    end
  end

end
