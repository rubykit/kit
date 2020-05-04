::ActiveAdmin.register Kit::Auth::Models::Read::OauthAccessGrant, as: 'OauthAccessGrant', namespace: :kit_auth_admin do
  menu label: 'OAuthAccessGrant', parent: 'OAuth'

  actions :all, except: [:new, :edit, :destroy]

  index do
    Kit::Auth::Admin::Tables::OauthAccessGrant.new(self).index
  end

  show do
    Kit::Auth::Admin::Tables::OauthAccessGrant.new(self).panel resource

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
